import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class DetachSkillsUseCase
    implements UseCase<Either<Failure, WorkerProfile>, List<int>> {
  final WorkerProfileRepository repository;

  DetachSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({List<int>? params}) {
    return repository.detachSkills(params ?? const []);
  }
}
