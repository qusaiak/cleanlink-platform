import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class UpdateAvailabilityUseCase
    implements UseCase<Either<Failure, WorkerProfile>, WorkerAvailability> {
  final WorkerProfileRepository repository;

  UpdateAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({
    WorkerAvailability? params,
  }) async {
    if (params == WorkerAvailability.busy) {
      return const Left(
        ValidationFailure(
          'The busy status is set automatically by the system when a task is '
          'assigned; it can never be selected manually.',
          ErrorCode.manualBusyNotAllowed,
        ),
      );
    }
    return repository.updateAvailability(params!);
  }
}
