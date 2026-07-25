import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Updates the worker's availability (available / busy / offline).
class UpdateAvailabilityUseCase
    implements UseCase<Either<Failure, WorkerProfile>, WorkerAvailability> {
  final WorkerProfileRepository repository;

  UpdateAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({WorkerAvailability? params}) {
    return repository.updateAvailability(params!);
  }
}
