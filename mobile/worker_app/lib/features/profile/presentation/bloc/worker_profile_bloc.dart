import 'dart:async';

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

class WorkerProfileBloc extends Bloc<WorkerProfileEvent, WorkerProfileState> {
  final GetWorkerProfileUseCase getProfile;
  final UpdateAvailabilityUseCase updateAvailability;
  final UpdateWorkerProfileUseCase updateProfile;
  final UpdateProfileImageUseCase updateProfileImage;
  final GetSkillsUseCase getSkills;
  final AttachSkillsUseCase attachSkills;
  final DetachSkillsUseCase detachSkills;

  final GetDailyTasksUseCase getDailyTasks;
  final WatchDailyTasksUseCase watchDailyTasks;

  StreamSubscription<DailyTasks>? _ordersSub;

  bool _savingImage = false;

  StreamSubscription<String>? _avatarSub;

  StreamSubscription<List<Map<String, dynamic>>>? _skillsSub;

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

    _ordersSub = watchDailyTasks().listen((daily) {
      if (!isClosed) add(OrdersChanged(_hasActiveOrder(daily)));
    });

    _avatarSub = LoginSession.avatarChanges.listen((url) {
      if (!isClosed) add(ProfileImageChanged(url));
    });

    _skillsSub = LoginSession.skillsChanges.listen((cached) {
      if (!isClosed) add(SkillsChangedExternally(_skillsFromCache(cached)));
    });

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

  List<WorkerSkill> _skillsFromCache(List<Map<String, dynamic>> cached) =>
      SkillModel.listFrom(cached);

  bool _hasActiveOrder(DailyTasks daily) =>
      daily.tasks.any((task) => task.status != TaskStatus.completed);

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

      final cached = LoginSession.avatarUrl ?? '';
      final sameImage =
          cached.isNotEmpty &&
          ApiUrlParameters.stripCacheBuster(cached) ==
              ApiUrlParameters.stripCacheBuster(profile.avatarUrl);
      if (profile.avatarUrl.isNotEmpty && !sameImage) {
        await LoginSession.saveProfileImage(displayUrl: profile.avatarUrl);
      }

      if (!_sameSkills(_skillsFromCache(LoginSession.skills), profile.skills)) {
        await LoginSession.saveSkills([
          for (final skill in profile.skills) SkillModel.cacheJsonOf(skill),
        ]);
      }
      emit(
        state.copyWith(
          status: WorkerProfileStatus.loaded,

          profile: sameImage ? profile.copyWith(avatarUrl: cached) : profile,
        ),
      );
    }

    unawaited(getDailyTasks());
  }

  WorkerProfile _withLoginSession(WorkerProfile profile) => profile.copyWith(
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

    emit(state.copyWith(hasActiveOrder: event.hasActiveOrder));
  }

  Future<void> _onChangeAvailability(
    ChangeAvailability event,
    Emitter<WorkerProfileState> emit,
  ) async {
    if (state.hasActiveOrder) return;

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
        emit(
          state.copyWith(status: WorkerProfileStatus.loaded, profile: merged),
        );
      },
    );
  }

  Future<void> _onSaveProfileField(
    SaveProfileField event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;

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

        if (event.address != null) LoginSession.address = merged.address;
        if (event.phone != null) LoginSession.phone = merged.phone;
        emit(
          state.copyWith(
            status: WorkerProfileStatus.saveFieldSuccess,
            profile: merged,
          ),
        );
        emit(
          state.copyWith(status: WorkerProfileStatus.loaded, profile: merged),
        );
      },
    );
  }

  Future<void> _onSaveProfileImage(
    SaveProfileImage event,
    Emitter<WorkerProfileState> emit,
  ) async {
    if (_savingImage) return;
    _savingImage = true;

    final current = state.profile;
    final previousAvatar = current?.avatarUrl ?? '';

    try {
      emit(
        state.copyWith(
          status: WorkerProfileStatus.savingField,
          pendingImage: event.image,
        ),
      );

      final result = await updateProfileImage(params: event.image);

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

      final serverAvatar = updated?.avatarUrl ?? '';
      final baseAvatar = serverAvatar.isNotEmpty
          ? serverAvatar
          : previousAvatar;

      await evictImageUrl(previousAvatar);
      if (baseAvatar != previousAvatar) await evictImageUrl(baseAvatar);

      final newAvatar = ApiUrlParameters.withCacheBuster(
        baseAvatar,
        version: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      final merged = current == null
          ? updated
          : (newAvatar.isNotEmpty
                ? current.copyWith(avatarUrl: newAvatar)
                : current);

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

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<WorkerProfileState> emit,
  ) async {
    if (state.allSkills.isEmpty && !state.loadingSkills) return;
    await _onLoadSkills(const LoadAvailableSkills(), emit);
  }

  Future<void> _onAttachSkill(
    AttachSkill event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;

    if (state.isSkillPending(event.skillId)) return;

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

  Future<void> _runSkillChange({
    required Emitter<WorkerProfileState> emit,
    required int skillId,
    required List<WorkerSkill> rollbackTo,
    required WorkerProfileStatus successStatus,
    required Future<Either<Failure, WorkerProfile>> Function() request,
  }) async {
    final result = await request();

    final stillPending = {...state.pendingSkillIds}..remove(skillId);

    await result.fold(
      (failure) async {
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

  Future<WorkerProfile> _adoptServerWorker(WorkerProfile updated) async {
    final current = state.profile;
    final merged = (current == null ? updated : _mergeServer(current, updated))
        .copyWith(skills: updated.skills);

    await LoginSession.saveSkills([
      for (final skill in merged.skills) SkillModel.cacheJsonOf(skill),
    ]);

    await LoginSession.saveIdentity(
      address: merged.address.isNotEmpty ? merged.address : null,
      phone: merged.phone.isNotEmpty ? merged.phone : null,
      employeeId: merged.employeeId.isNotEmpty ? merged.employeeId : null,
    );

    return merged;
  }

  Future<void> _onSkillsChangedExternally(
    SkillsChangedExternally event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;

    if (_sameSkills(current.skills, event.skills)) return;

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

  WorkerSkill? _dictionaryEntry(int skillId) {
    for (final skill in state.allSkills) {
      if (skill.id == skillId) return skill;
    }
    return null;
  }

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
    );
  }
}
