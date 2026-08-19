part of 'worker_profile_bloc.dart';

enum WorkerProfileStatus {
  initial,
  loading,
  loaded,
  error,
  updating,
  updateSuccess,
  updateFailure,
  // Inline profile-field edit (name / email / phone / address / experience).
  savingField,
  saveFieldSuccess,
  saveFieldFailure,
  // Skills attach / detach.
  skillAttached,
  skillDetached,
  skillsFailure,
}

class WorkerProfileState extends Equatable {
  final WorkerProfileStatus status;
  final WorkerProfile? profile;

  /// The availability currently being saved (drives the per-row spinner).
  final WorkerAvailability? updatingTo;
  final Failure? error;

  /// The picked photo ([XFile]) currently being uploaded — drives the
  /// optimistic avatar preview + spinner while the multipart save is in flight.
  /// Transient: set only on the `savingField` emit of a photo save and cleared
  /// automatically on every following emit.
  final XFile? pendingImage;

  /// Whether the worker currently has at least one active (not completed and
  /// not cancelled) order — derived from the shared tasks stream. When true,
  /// the worker displays as `busy`.
  final bool hasActiveOrder;

  /// The skills DICTIONARY (`GET /api/skills`), already localized by the server
  /// for the current language and re-fetched whenever that language changes.
  final List<WorkerSkill> allSkills;

  /// Whether the dictionary is being fetched.
  final bool loadingSkills;

  /// Ids with an attach/detach request IN FLIGHT right now.
  ///
  /// A set rather than a single bool so the row that was tapped can show its
  /// own spinner while the rest of the list stays usable — and so a second tap
  /// on the SAME skill is rejected outright (the duplicate-request guard),
  /// which a shared bool could not express.
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

  /// Whether ANY skill change is in flight (drives the section-level spinner).
  bool get savingSkills => pendingSkillIds.isNotEmpty;

  /// Whether [skillId] specifically is being attached/detached right now.
  bool isSkillPending(int skillId) => pendingSkillIds.contains(skillId);

  /// The worker's own skills, sorted for a stable order that does not jump
  /// around when the server returns them in a different sequence.
  List<WorkerSkill> get ownedSkills {
    final owned = [...?profile?.skills]..sort((a, b) => a.id.compareTo(b.id));
    return owned;
  }

  /// The status shown in the UI: `busy` whenever an order is active, otherwise
  /// the worker's chosen base value. Null until the profile loads.
  WorkerAvailability? get effectiveAvailability => profile == null
      ? null
      : effectiveWorkerStatus(profile!.availability, hasActiveOrder);

  /// Skills the worker does NOT already have — the dictionary minus the
  /// worker's own skills, compared by `id`. This is what the "add" list offers,
  /// so an already-owned skill is never presented for attaching again.
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
      // Transient: cleared on every emit unless explicitly set.
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
