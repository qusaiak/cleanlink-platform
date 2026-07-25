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

/// Save an edited profile field (email and/or employee id). Only the provided
/// (non-null) fields are sent to the backend.
class SaveProfileField extends WorkerProfileEvent {
  final String? email;
  final String? employeeId;

  const SaveProfileField({this.email, this.employeeId});

  @override
  List<Object?> get props => [email, employeeId];
}
