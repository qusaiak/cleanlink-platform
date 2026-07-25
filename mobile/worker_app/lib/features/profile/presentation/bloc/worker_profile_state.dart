part of 'worker_profile_bloc.dart';

enum WorkerProfileStatus {
  initial,
  loading,
  loaded,
  error,
  updating,
  updateSuccess,
  updateFailure,
  // Inline profile-field edit (email / employee id).
  savingField,
  saveFieldSuccess,
  saveFieldFailure,
}

class WorkerProfileState extends Equatable {
  final WorkerProfileStatus status;
  final WorkerProfile? profile;

  /// The availability currently being saved (drives the per-row spinner).
  final WorkerAvailability? updatingTo;
  final Failure? error;

  const WorkerProfileState({
    this.status = WorkerProfileStatus.initial,
    this.profile,
    this.updatingTo,
    this.error,
  });

  WorkerProfileState copyWith({
    WorkerProfileStatus? status,
    WorkerProfile? profile,
    WorkerAvailability? updatingTo,
    Failure? error,
  }) {
    return WorkerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      updatingTo: updatingTo,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, profile, updatingTo, error];
}
