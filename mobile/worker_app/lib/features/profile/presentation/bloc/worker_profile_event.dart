part of 'worker_profile_bloc.dart';

sealed class WorkerProfileEvent extends Equatable {
  const WorkerProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkerProfile extends WorkerProfileEvent {
  const LoadWorkerProfile();
}

class ChangeAvailability extends WorkerProfileEvent {
  final WorkerAvailability availability;

  const ChangeAvailability(this.availability);

  @override
  List<Object?> get props => [availability];
}

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

class SaveProfileImage extends WorkerProfileEvent {
  final XFile image;

  const SaveProfileImage(this.image);

  @override
  List<Object?> get props => [image.path];
}

class ProfileImageChanged extends WorkerProfileEvent {
  final String avatarUrl;

  const ProfileImageChanged(this.avatarUrl);

  @override
  List<Object?> get props => [avatarUrl];
}

class LoadAvailableSkills extends WorkerProfileEvent {
  const LoadAvailableSkills();
}

class AttachSkill extends WorkerProfileEvent {
  final int skillId;

  const AttachSkill(this.skillId);

  @override
  List<Object?> get props => [skillId];
}

class DetachSkill extends WorkerProfileEvent {
  final int skillId;

  const DetachSkill(this.skillId);

  @override
  List<Object?> get props => [skillId];
}

class SaveSkillsSelection extends WorkerProfileEvent {
  final Set<int> skillIds;

  const SaveSkillsSelection(this.skillIds);

  @override
  List<Object?> get props => [skillIds];
}

class LanguageChanged extends WorkerProfileEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class SkillsChangedExternally extends WorkerProfileEvent {
  final List<WorkerSkill> skills;

  const SkillsChangedExternally(this.skills);

  @override
  List<Object?> get props => [skills];
}

class OrdersChanged extends WorkerProfileEvent {
  final bool hasActiveOrder;

  const OrdersChanged(this.hasActiveOrder);

  @override
  List<Object?> get props => [hasActiveOrder];
}
