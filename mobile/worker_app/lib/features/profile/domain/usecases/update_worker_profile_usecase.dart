import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Fields the worker can edit inline on the profile screen. Only the non-null
/// ones are sent to the backend.
class UpdateProfileParams extends Equatable {
  final String? email;
  final String? employeeId;

  const UpdateProfileParams({this.email, this.employeeId});

  @override
  List<Object?> get props => [email, employeeId];
}

/// Updates editable worker profile fields (email / employee id).
class UpdateWorkerProfileUseCase
    implements UseCase<Either<Failure, WorkerProfile>, UpdateProfileParams> {
  final WorkerProfileRepository repository;

  UpdateWorkerProfileUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({UpdateProfileParams? params}) {
    return repository.updateProfile(
      email: params?.email,
      employeeId: params?.employeeId,
    );
  }
}
