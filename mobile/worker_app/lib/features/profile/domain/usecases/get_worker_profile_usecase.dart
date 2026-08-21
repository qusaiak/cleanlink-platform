import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class GetWorkerProfileUseCase
    implements UseCase<Either<Failure, WorkerProfile>, NoParams> {
  final WorkerProfileRepository repository;

  GetWorkerProfileUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({NoParams? params}) {
    return repository.getProfile();
  }
}
