part of 'worker_profile_bloc.dart';

/// Events for the worker profile screen.
sealed class WorkerProfileEvent extends Equatable {
  const WorkerProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or refresh) the worker's profile.
class LoadWorkerProfile extends WorkerProfileEvent {
  const LoadWorkerProfile();
}

/// Change the worker's availability (available / busy / offline).
class ChangeAvailability extends WorkerProfileEvent {
  final WorkerAvailability availability;

  const ChangeAvailability(this.availability);

  @override
  List<Object?> get props => [availability];
}

/// Save an edited profile field (name / email / address / phone / experience).
/// Only the provided (non-null) fields are sent to the backend via
/// `PUT /api/worker-profiles`. The photo is handled separately by
/// [SaveProfileImage].
class SaveProfileField extends WorkerProfileEvent {
  final String? fullname;
  final String? email;
  final String? address;
  final String? phone;
  final int? experienceYears;

  const SaveProfileField({
    this.fullname,
    this.email,
    this.address,
    this.phone,
    this.experienceYears,
  });

  @override
  List<Object?> get props => [fullname, email, address, phone, experienceYears];
}

/// Update ONLY the profile photo. The picked [image] ([XFile]) is uploaded as
/// multipart with no other fields, then the stored path it returns is pinned
/// onto the profile via `POST /api/worker-profiles/update-image`.
class SaveProfileImage extends WorkerProfileEvent {
  final XFile image;

  const SaveProfileImage(this.image);

  @override
  List<Object?> get props => [image.path];
}

/// Internal: the cached (server-confirmed) avatar changed — either this bloc
/// saved a new photo or another screen's instance did. Dispatched only by the
/// bloc's own subscription to [LoginSession.avatarChanges], never from the UI,
/// and never triggers a request.
class ProfileImageChanged extends WorkerProfileEvent {
  final String avatarUrl;

  const ProfileImageChanged(this.avatarUrl);

  @override
  List<Object?> get props => [avatarUrl];
}

/// Load the skills DICTIONARY (`GET /api/skills`). The names come back already
/// localized by the server, so this is re-run on every language change.
class LoadAvailableSkills extends WorkerProfileEvent {
  const LoadAvailableSkills();
}

/// Attach [skillId] to the worker (`POST /api/worker/update-skills`). Only the
/// new id is sent; the response's full worker object becomes the new truth.
class AttachSkill extends WorkerProfileEvent {
  final int skillId;

  const AttachSkill(this.skillId);

  @override
  List<Object?> get props => [skillId];
}

/// Detach [skillId] from the worker (`DELETE /api/worker/detach-skills`).
class DetachSkill extends WorkerProfileEvent {
  final int skillId;

  const DetachSkill(this.skillId);

  @override
  List<Object?> get props => [skillId];
}

/// Internal: the app language changed, so the server-localized skills
/// dictionary currently in state is in the wrong language and is fetched again.
/// Dispatched only by the bloc's subscription to [AppLanguageInfo.changes];
/// the worker's OWN skills carry both names and re-localize without a request.
class LanguageChanged extends WorkerProfileEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

/// Internal: the cached (server-confirmed) skill set changed — this bloc
/// attached/detached a skill, or another screen's instance did. Dispatched only
/// by the bloc's subscription to [LoginSession.skillsChanges], and never
/// triggers a request.
class SkillsChangedExternally extends WorkerProfileEvent {
  final List<WorkerSkill> skills;

  const SkillsChangedExternally(this.skills);

  @override
  List<Object?> get props => [skills];
}

/// Internal: the worker's orders changed (from the shared tasks stream), so the
/// derived `busy` status is recomputed. Dispatched only by the bloc's own
/// subscription, never from the UI.
class OrdersChanged extends WorkerProfileEvent {
  final bool hasActiveOrder;

  const OrdersChanged(this.hasActiveOrder);

  @override
  List<Object?> get props => [hasActiveOrder];
}
