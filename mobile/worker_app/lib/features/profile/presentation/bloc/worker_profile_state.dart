part of 'worker_profile_bloc.dart';

enum WorkerProfileStatus {
  initial,
  loading,
  loaded,
  error,
  updating,
  updateSuccess,
  updateFailure,

  savingField,
  saveFieldSuccess,
  saveFieldFailure,

  skillAttached,
  skillDetached,
  skillsFailure,
}

class WorkerProfileState extends Equatable {
  final WorkerProfileStatus status;
  final WorkerProfile? profile;

  final WorkerAvailability? updatingTo;
  final Failure? error;

  final XFile? pendingImage;

  final bool hasActiveOrder;

  final List<WorkerSkill> allSkills;

  final bool loadingSkills;

  final Set<int> pendingSkillIds;

  const WorkerProfileState({
    this.status = WorkerProfileStatus.initial,
    this.profile,
    this.updatingTo,
    this.error,
    this.pendingImage,
    this.hasActiveOrder = false,
    this.allSkills = const [],
    this.loadingSkills = false,
    this.pendingSkillIds = const {},
  });

  bool get savingSkills => pendingSkillIds.isNotEmpty;

  bool isSkillPending(int skillId) => pendingSkillIds.contains(skillId);

  List<WorkerSkill> get ownedSkills {
    final owned = [...?profile?.skills]..sort((a, b) => a.id.compareTo(b.id));
    return owned;
  }

  WorkerAvailability? get effectiveAvailability => profile == null
      ? null
      : effectiveWorkerStatus(profile!.availability, hasActiveOrder);

  List<WorkerSkill> get availableSkills {
    final owned = {
      for (final s in profile?.skills ?? const <WorkerSkill>[]) s.id,
    };
    return allSkills.where((s) => !owned.contains(s.id)).toList();
  }

  WorkerProfileState copyWith({
    WorkerProfileStatus? status,
    WorkerProfile? profile,
    WorkerAvailability? updatingTo,
    Failure? error,
    XFile? pendingImage,
    bool? hasActiveOrder,
    List<WorkerSkill>? allSkills,
    bool? loadingSkills,
    Set<int>? pendingSkillIds,
  }) {
    return WorkerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,

      updatingTo: updatingTo,
      error: error,
      pendingImage: pendingImage,
      hasActiveOrder: hasActiveOrder ?? this.hasActiveOrder,
      allSkills: allSkills ?? this.allSkills,
      loadingSkills: loadingSkills ?? this.loadingSkills,
      pendingSkillIds: pendingSkillIds ?? this.pendingSkillIds,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    updatingTo,
    error,
    pendingImage?.path,
    hasActiveOrder,
    allSkills,
    loadingSkills,
    pendingSkillIds,
  ];
}
