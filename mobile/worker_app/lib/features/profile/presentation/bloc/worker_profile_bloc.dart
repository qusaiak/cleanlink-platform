import 'dart:async';

// `show Either` deliberately: dartz also exports a `Task` type, which would
// collide with the app's own `Task` entity imported below.
import 'package:dartz/dartz.dart' show Either;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/session/login_session.dart';
import '../../../../core/utils/functions/evict_image_cache.dart';
import '../../../tasks/domain/entities/daily_tasks.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/usecases/get_daily_tasks_usecase.dart';
import '../../../tasks/domain/usecases/watch_daily_tasks_usecase.dart';
import '../../data/models/skill_model.dart';
import '../../domain/entities/worker_profile.dart';
import '../../domain/usecases/attach_skills_usecase.dart';
import '../../domain/usecases/detach_skills_usecase.dart';
import '../../domain/usecases/get_skills_usecase.dart';
import '../../domain/usecases/get_worker_profile_usecase.dart';
import '../../domain/usecases/update_availability_usecase.dart';
import '../../domain/usecases/update_profile_image_usecase.dart';
import '../../domain/usecases/update_worker_profile_usecase.dart';

part 'worker_profile_event.dart';
part 'worker_profile_state.dart';

/// Drives the worker profile screen: loads the profile, edits its fields
/// (`PUT /api/worker-profiles`), manages skills, and derives the `busy` status
/// from the worker's live orders. Kept separate from [ProfileBloc]
/// (theme/language) so concerns stay isolated.
class WorkerProfileBloc extends Bloc<WorkerProfileEvent, WorkerProfileState> {
  final GetWorkerProfileUseCase getProfile;
  final UpdateAvailabilityUseCase updateAvailability;
  final UpdateWorkerProfileUseCase updateProfile;
  final UpdateProfileImageUseCase updateProfileImage;
  final GetSkillsUseCase getSkills;
  final AttachSkillsUseCase attachSkills;
  final DetachSkillsUseCase detachSkills;

  /// The orders the app already loads — reused (no new endpoint) to derive the
  /// `busy` status and to react when the order list changes.
  final GetDailyTasksUseCase getDailyTasks;
  final WatchDailyTasksUseCase watchDailyTasks;

  StreamSubscription<DailyTasks>? _ordersSub;

  /// Guards against a second photo save starting while one is still running
  /// (a double tap on the camera button, or the sheet re-opened mid-upload).
  bool _savingImage = false;

  /// Keeps this instance's avatar in step with the session cache. Every screen
  /// builds its OWN [WorkerProfileBloc] (the bloc is registered as a factory),
  /// so without this the home top bar and the drawer would keep showing the old
  /// picture after the profile screen changed it.
  StreamSubscription<String>? _avatarSub;

  /// Same idea for the skill set, which any screen can change.
  StreamSubscription<List<Map<String, dynamic>>>? _skillsSub;

  /// Re-fetches the server-localized skills dictionary on a language switch.
  StreamSubscription<String>? _languageSub;

  WorkerProfileBloc({
    required this.getProfile,
    required this.updateAvailability,
    required this.updateProfile,
    required this.updateProfileImage,
    required this.getSkills,
    required this.attachSkills,
    required this.detachSkills,
    required this.getDailyTasks,
    required this.watchDailyTasks,
  }) : super(const WorkerProfileState()) {
    on<LoadWorkerProfile>(_onLoad);
    on<ChangeAvailability>(_onChangeAvailability);
    on<SaveProfileField>(_onSaveProfileField);
    on<SaveProfileImage>(_onSaveProfileImage);
    on<LoadAvailableSkills>(_onLoadSkills);
    on<AttachSkill>(_onAttachSkill);
    on<DetachSkill>(_onDetachSkill);
    on<LanguageChanged>(_onLanguageChanged);
    on<SkillsChangedExternally>(_onSkillsChangedExternally);
    on<OrdersChanged>(_onOrdersChanged);
    on<ProfileImageChanged>(_onProfileImageChanged);

    // Recompute `busy` whenever the shared order list changes (a load, or a
    // status update from any screen). The stream is the tasks repository's
    // single source of truth.
    _ordersSub = watchDailyTasks().listen((daily) {
      if (!isClosed) add(OrdersChanged(_hasActiveOrder(daily)));
    });

    // Same idea for the photo: the session cache is the single source of truth
    // for the confirmed avatar, and it broadcasts on every change.
    _avatarSub = LoginSession.avatarChanges.listen((url) {
      if (!isClosed) add(ProfileImageChanged(url));
    });

    // …and for the skills, so an attach/detach performed on the dedicated
    // skills screen is reflected on the profile screen (and anywhere else
    // holding an instance) without a re-fetch or a restart.
    _skillsSub = LoginSession.skillsChanges.listen((cached) {
      if (!isClosed) add(SkillsChangedExternally(_skillsFromCache(cached)));
    });

    // The dictionary is translated by the SERVER, so a language switch makes
    // the copy in state wrong; asking again is the only correct fix.
    _languageSub = AppLanguageInfo.changes.listen((code) {
      if (!isClosed) add(LanguageChanged(code));
    });
  }

  @override
  Future<void> close() {
    _ordersSub?.cancel();
    _avatarSub?.cancel();
    _skillsSub?.cancel();
    _languageSub?.cancel();
    return super.close();
  }

  /// Turns the raw `{id, name_ar, name_en}` maps kept in [LoginSession] back
  /// into entities, through the SAME parser the network responses use.
  List<WorkerSkill> _skillsFromCache(List<Map<String, dynamic>> cached) =>
      SkillModel.listFrom(cached);

  /// Active = at least one task not completed and not cancelled — the same
  /// derivation the daily-tasks header uses for "remaining", so the two agree.
  bool _hasActiveOrder(DailyTasks daily) => daily.tasks.any(
        (t) =>
            t.status != TaskStatus.completed &&
            t.status != TaskStatus.cancelled,
      );

  Future<void> _onLoad(
    LoadWorkerProfile event,
    Emitter<WorkerProfileState> emit,
  ) async {
    emit(state.copyWith(status: WorkerProfileStatus.loading));
    final result = await getProfile();

    final loaded = result.fold<WorkerProfile?>((_) => null, (p) => p);
    if (loaded == null) {
      emit(
        state.copyWith(
          status: WorkerProfileStatus.error,
          error: result.fold<Failure?>((f) => f, (_) => null),
        ),
      );
    } else {
      final profile = _withLoginSession(loaded);
      // The fetch is authoritative, so refresh the cached avatar from it (and
      // let every other screen know) whenever it points at a DIFFERENT image.
      //
      // Compared with the cache-buster stripped: right after a photo change the
      // cached url carries a `?v=` that `/me` naturally does not, and they name
      // the same file. Overwriting it there would drop the buster and make the
      // avatar download all over again for nothing.
      final cached = LoginSession.avatarUrl ?? '';
      final sameImage =
          cached.isNotEmpty &&
          ApiUrlParameters.stripCacheBuster(cached) ==
              ApiUrlParameters.stripCacheBuster(profile.avatarUrl);
      if (profile.avatarUrl.isNotEmpty && !sameImage) {
        await LoginSession.saveProfileImage(displayUrl: profile.avatarUrl);
      }
      // The fetch is authoritative for the skill set too — cache it so a cold
      // start and every other bloc instance start from the same list.
      if (!_sameSkills(_skillsFromCache(LoginSession.skills), profile.skills)) {
        await LoginSession.saveSkills([
          for (final skill in profile.skills) SkillModel.cacheJsonOf(skill),
        ]);
      }
      emit(
        state.copyWith(
          status: WorkerProfileStatus.loaded,
          // Same image → keep the cached spelling (with its buster) so the
          // widget's url does not change and the photo is not re-downloaded.
          profile: sameImage ? profile.copyWith(avatarUrl: cached) : profile,
        ),
      );
    }
    // Prime the orders so `busy` is correct even if the tasks screen wasn't
    // opened first; the fetch emits on the shared stream (→ [OrdersChanged]).
    // Fire-and-forget: profile display never waits on it.
    unawaited(getDailyTasks());
  }

  /// The profile fetch (`/api/worker-profiles/me`) is the source of truth —
  /// the worker can edit address/phone after logging in, so the values cached
  /// at login ([LoginSession]) are only used to FILL fields the fetch left
  /// empty, never to override fresh server data.
  WorkerProfile _withLoginSession(WorkerProfile profile) => profile.copyWith(
    // Same rule for the photo: the cached one only fills a gap, it never
    // overrides what the server just returned.
    avatarUrl: profile.avatarUrl.isEmpty
        ? (LoginSession.avatarUrl ?? '')
        : profile.avatarUrl,
    employeeId: profile.employeeId.isEmpty
        ? (LoginSession.employeeId ?? '')
        : profile.employeeId,
    address: profile.address.isEmpty
        ? (LoginSession.address ?? '')
        : profile.address,
    phone: profile.phone.isEmpty ? (LoginSession.phone ?? '') : profile.phone,
  );

  Future<void> _onOrdersChanged(
    OrdersChanged event,
    Emitter<WorkerProfileState> emit,
  ) async {
    if (event.hasActiveOrder == state.hasActiveOrder) return;
    // `busy` is purely derived; the chosen base availability in `profile`
    // is untouched, so it is restored automatically once no order is active.
    emit(state.copyWith(hasActiveOrder: event.hasActiveOrder));
  }

  Future<void> _onChangeAvailability(
    ChangeAvailability event,
    Emitter<WorkerProfileState> emit,
  ) async {
    // While the worker is (derived) busy, the choice is locked.
    if (state.hasActiveOrder) return;
    // `busy` can never be chosen manually; no-op if already the current base.
    if (event.availability == WorkerAvailability.busy) return;
    if (state.profile?.availability == event.availability) return;

    emit(
      state.copyWith(
        status: WorkerProfileStatus.updating,
        updatingTo: event.availability,
      ),
    );

    final result = await updateAvailability(params: event.availability);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WorkerProfileStatus.updateFailure,
          error: failure,
        ),
      ),
      (updated) {
        final merged = _mergeServer(state.profile, updated);
        emit(
          state.copyWith(
            status: WorkerProfileStatus.updateSuccess,
            profile: merged,
          ),
        );
        emit(state.copyWith(status: WorkerProfileStatus.loaded, profile: merged));
      },
    );
  }

  Future<void> _onSaveProfileField(
    SaveProfileField event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    // No-op if nothing actually changed (avoids a needless round-trip).
    final unchanged =
        (event.fullname == null || event.fullname == current?.name) &&
        (event.email == null || event.email == current?.email) &&
        (event.address == null || event.address == current?.address) &&
        (event.phone == null || event.phone == current?.phone) &&
        (event.experienceYears == null ||
            event.experienceYears == current?.experienceYears);
    if (unchanged) return;

    emit(state.copyWith(status: WorkerProfileStatus.savingField));

    final result = await updateProfile(
      params: UpdateProfileParams(
        fullname: event.fullname,
        email: event.email,
        address: event.address,
        phone: event.phone,
        experienceYears: event.experienceYears,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WorkerProfileStatus.saveFieldFailure,
          error: failure,
        ),
      ),
      (updated) {
        final merged = _mergeServer(current, updated);
        // Keep the login-time cache in step with the edit.
        if (event.address != null) LoginSession.address = merged.address;
        if (event.phone != null) LoginSession.phone = merged.phone;
        emit(
          state.copyWith(
            status: WorkerProfileStatus.saveFieldSuccess,
            profile: merged,
          ),
        );
        emit(state.copyWith(status: WorkerProfileStatus.loaded, profile: merged));
      },
    );
  }

  /// Saves the new profile photo and refreshes the avatar everywhere.
  ///
  /// Two things beyond the upload itself are needed for the picture to change
  /// on screen straight away:
  ///  - the confirmed URL goes into the shared session cache, which broadcasts
  ///    it, so every screen holding its own bloc instance rebuilds;
  ///  - the OLD image is evicted and the new URL carries a cache-buster,
  ///    because the server normally keeps serving the avatar from the SAME
  ///    URL — and both Flutter's ImageCache and CachedNetworkImage key on that
  ///    URL, so without this they keep painting the old bytes no matter what
  ///    the state says.
  Future<void> _onSaveProfileImage(
    SaveProfileImage event,
    Emitter<WorkerProfileState> emit,
  ) async {
    // A second save while one is in flight would race the first: two uploads,
    // two responses, and the slower one wins.
    if (_savingImage) return;
    _savingImage = true;

    final current = state.profile;
    final previousAvatar = current?.avatarUrl ?? '';

    try {
      // Carry the picked file so the avatar shows it as an optimistic preview
      // (with a spinner) while the upload is in flight. It is transient, so the
      // success/failure emits below clear it automatically — and by then the
      // state already holds the new network URL, so the preview is replaced by
      // the new photo rather than flicking back to the old one.
      emit(
        state.copyWith(
          status: WorkerProfileStatus.savingField,
          pendingImage: event.image,
        ),
      );

      final result = await updateProfileImage(params: event.image);

      // Only a genuine failure of the UPLOAD reaches here as a Left — the data
      // source no longer turns a parsing problem or a failed follow-up call
      // into a failure, because in those cases the photo was already saved.
      final failure = result.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) {
        emit(
          state.copyWith(
            status: WorkerProfileStatus.saveFieldFailure,
            error: failure,
          ),
        );
        return;
      }

      final updated = result.fold<WorkerProfile?>((_) => null, (p) => p);

      // The server's URL is preferred; when it did not report one, the photo
      // still changed at the previous URL — so that URL is reused and refreshed
      // by the eviction + cache-buster below.
      final serverAvatar = updated?.avatarUrl ?? '';
      final baseAvatar = serverAvatar.isNotEmpty ? serverAvatar : previousAvatar;

      // Drop every cached copy of what is on screen now, then hand the widgets
      // a URL they have never seen. Either alone is unreliable; together the
      // new bytes are guaranteed to be fetched.
      await evictImageUrl(previousAvatar);
      if (baseAvatar != previousAvatar) await evictImageUrl(baseAvatar);

      final newAvatar = ApiUrlParameters.withCacheBuster(
        baseAvatar,
        version: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // Image-only endpoint → merge ONLY the avatar. Blanket-merging the
      // response would let its empty/default fields (rating, experience,
      // availability) overwrite real values.
      final merged = current == null
          ? updated
          : (newAvatar.isNotEmpty
                ? current.copyWith(avatarUrl: newAvatar)
                : current);

      // The confirmed photo becomes the cached one (SharedPreferences) and is
      // broadcast, so the home top bar and the drawer update immediately — no
      // manual refresh, no restart. Awaited so success is only reported once
      // the cache really holds it.
      if (newAvatar.isNotEmpty) {
        await LoginSession.saveProfileImage(displayUrl: newAvatar);
      }

      emit(
        state.copyWith(
          status: WorkerProfileStatus.saveFieldSuccess,
          profile: merged,
        ),
      );
      emit(state.copyWith(status: WorkerProfileStatus.loaded, profile: merged));
    } finally {
      _savingImage = false;
    }
  }

  /// The cached avatar changed (this screen saved a new photo, or another one
  /// did). Purely local — never triggers a request.
  Future<void> _onProfileImageChanged(
    ProfileImageChanged event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null || event.avatarUrl.isEmpty) return;
    if (current.avatarUrl == event.avatarUrl) return;
    emit(
      state.copyWith(
        status: state.status,
        profile: current.copyWith(avatarUrl: event.avatarUrl),
      ),
    );
  }

  /// Fetches the skills DICTIONARY. The names arrive already translated by the
  /// server (from the `Accept-Language` the interceptor sends) — nothing is
  /// translated here.
  Future<void> _onLoadSkills(
    LoadAvailableSkills event,
    Emitter<WorkerProfileState> emit,
  ) async {
    emit(state.copyWith(loadingSkills: true));
    final result = await getSkills();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WorkerProfileStatus.skillsFailure,
          error: failure,
          loadingSkills: false,
        ),
      ),
      (skills) => emit(state.copyWith(allSkills: skills, loadingSkills: false)),
    );
  }

  /// Language switched → the dictionary in state is in the previous language.
  ///
  /// Only re-fetched when this instance actually holds one: the bloc is a
  /// factory and several screens (the home drawer among them) build it purely
  /// for the avatar, and must not fire a skills request they have no use for.
  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<WorkerProfileState> emit,
  ) async {
    if (state.allSkills.isEmpty && !state.loadingSkills) return;
    await _onLoadSkills(const LoadAvailableSkills(), emit);
  }

  /// Attaches one skill — `POST /api/worker/update-skills` with ONLY the new id
  /// (the endpoint adds; it is not a whole-set replacement).
  ///
  /// Optimistic: the chip appears the moment it is tapped, then the server's
  /// response replaces the whole set. On failure the pre-tap set is restored,
  /// so the UI can never keep a skill the backend rejected.
  Future<void> _onAttachSkill(
    AttachSkill event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;
    // Duplicate-request guard: a second tap on the same skill while the first
    // is still in flight is dropped, not queued.
    if (state.isSkillPending(event.skillId)) return;
    // Already owned — defensive; the "add" list never offers an owned skill.
    if (current.skills.any((s) => s.id == event.skillId)) return;

    final rollbackTo = current.skills;
    final optimistic = _dictionaryEntry(event.skillId);

    emit(
      state.copyWith(
        status: WorkerProfileStatus.loaded,
        profile: optimistic == null
            ? current
            : current.copyWith(skills: [...rollbackTo, optimistic]),
        pendingSkillIds: {...state.pendingSkillIds, event.skillId},
      ),
    );

    await _runSkillChange(
      emit: emit,
      skillId: event.skillId,
      rollbackTo: rollbackTo,
      successStatus: WorkerProfileStatus.skillAttached,
      request: () => attachSkills(params: [event.skillId]),
    );
  }

  /// Detaches one skill — `DELETE /api/worker/detach-skills`, same body and
  /// same optimistic/rollback contract as [_onAttachSkill].
  Future<void> _onDetachSkill(
    DetachSkill event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;
    if (state.isSkillPending(event.skillId)) return;
    if (!current.skills.any((s) => s.id == event.skillId)) return;

    final rollbackTo = current.skills;

    emit(
      state.copyWith(
        status: WorkerProfileStatus.loaded,
        profile: current.copyWith(
          skills: rollbackTo.where((s) => s.id != event.skillId).toList(),
        ),
        pendingSkillIds: {...state.pendingSkillIds, event.skillId},
      ),
    );

    await _runSkillChange(
      emit: emit,
      skillId: event.skillId,
      rollbackTo: rollbackTo,
      successStatus: WorkerProfileStatus.skillDetached,
      request: () => detachSkills(params: [event.skillId]),
    );
  }

  /// The half both attach and detach share: run the call, reconcile the state
  /// with what the server returned, or roll back and report the failure.
  ///
  /// The response carries the FULL updated user, so it is adopted wholesale
  /// (skills, profile fields, avatar) rather than re-fetched — that is what
  /// keeps every screen correct without a manual refresh.
  Future<void> _runSkillChange({
    required Emitter<WorkerProfileState> emit,
    required int skillId,
    required List<WorkerSkill> rollbackTo,
    required WorkerProfileStatus successStatus,
    required Future<Either<Failure, WorkerProfile>> Function() request,
  }) async {
    final result = await request();

    // Recomputed AFTER the await: another skill's request may have finished
    // meanwhile, and it must keep its own pending marker.
    final stillPending = {...state.pendingSkillIds}..remove(skillId);

    await result.fold(
      (failure) async {
        // Roll the optimistic change back — the server did not accept it.
        final reverted = state.profile?.copyWith(skills: rollbackTo);
        emit(
          state.copyWith(
            status: WorkerProfileStatus.skillsFailure,
            profile: reverted,
            error: failure,
            pendingSkillIds: stillPending,
          ),
        );
      },
      (updated) async {
        final merged = await _adoptServerWorker(updated);
        emit(
          state.copyWith(
            status: successStatus,
            profile: merged,
            pendingSkillIds: stillPending,
          ),
        );
        // Settle back to `loaded` so the one-shot success status cannot fire
        // its snackbar twice on a later rebuild.
        emit(
          state.copyWith(
            status: WorkerProfileStatus.loaded,
            profile: merged,
            pendingSkillIds: stillPending,
          ),
        );
      },
    );
  }

  /// Adopts the full user object an attach/detach response returns as the new
  /// source of truth, and mirrors it into the persisted session so the rest of
  /// the app (and the next cold start) agrees.
  ///
  /// Unlike [_mergeServer], `skills` here come STRICTLY from the response —
  /// that is the whole point of the call — while the other fields still fall
  /// back to the current values when the payload omits them.
  Future<WorkerProfile> _adoptServerWorker(WorkerProfile updated) async {
    final current = state.profile;
    final merged = (current == null ? updated : _mergeServer(current, updated))
        .copyWith(skills: updated.skills);

    // Persist the confirmed set (and broadcast it to every other bloc
    // instance). The URL inside `updated.avatarUrl` has already had its
    // `localhost` host rewritten by `WorkerProfileModel.fromMeJson`.
    await LoginSession.saveSkills([
      for (final skill in merged.skills) SkillModel.cacheJsonOf(skill),
    ]);

    // The same response also refreshes the cached identity fields.
    await LoginSession.saveIdentity(
      address: merged.address.isNotEmpty ? merged.address : null,
      phone: merged.phone.isNotEmpty ? merged.phone : null,
      employeeId: merged.employeeId.isNotEmpty ? merged.employeeId : null,
    );

    return merged;
  }

  /// The cached (server-confirmed) skill set changed elsewhere — adopt it
  /// locally. Purely local; never triggers a request.
  Future<void> _onSkillsChangedExternally(
    SkillsChangedExternally event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;
    // A change this instance made itself is already in state.
    if (_sameSkills(current.skills, event.skills)) return;
    // Never clobber a change this instance is still waiting on.
    if (state.savingSkills) return;

    emit(
      state.copyWith(
        status: state.status,
        profile: current.copyWith(skills: event.skills),
      ),
    );
  }

  bool _sameSkills(List<WorkerSkill> a, List<WorkerSkill> b) {
    if (a.length != b.length) return false;
    final aIds = {for (final s in a) s.id};
    return b.every((s) => aIds.contains(s.id));
  }

  /// The dictionary entry for [skillId], used for the optimistic chip; null
  /// when the dictionary has not been loaded (then no optimistic chip is shown
  /// and the server response supplies it).
  WorkerSkill? _dictionaryEntry(int skillId) {
    for (final skill in state.allSkills) {
      if (skill.id == skillId) return skill;
    }
    return null;
  }

  /// Merges a server-confirmed [updated] profile onto [current], preserving the
  /// fields the response omits — notably `skills` (the profile PUT/status
  /// endpoints don't return them) and the login-only `employeeId`. Empty
  /// strings from the response fall back to the current value.
  WorkerProfile _mergeServer(WorkerProfile? current, WorkerProfile updated) {
    if (current == null) return updated;
    return current.copyWith(
      name: updated.name.isNotEmpty ? updated.name : null,
      email: updated.email.isNotEmpty ? updated.email : null,
      role: updated.role.isNotEmpty ? updated.role : null,
      avatarUrl: updated.avatarUrl.isNotEmpty ? updated.avatarUrl : null,
      rating: updated.rating,
      availability: updated.availability,
      address: updated.address.isNotEmpty ? updated.address : null,
      phone: updated.phone.isNotEmpty ? updated.phone : null,
      experienceYears: updated.experienceYears,
      isLeader: updated.isLeader,
      // skills intentionally preserved from `current`.
    );
  }
}
