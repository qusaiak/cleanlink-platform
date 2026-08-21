import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class AttachSkillsUseCase
    implements UseCase<Either<Failure, WorkerProfile>, List<int>> {
  final WorkerProfileRepository repository;

  AttachSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({List<int>? params}) {
    return repository.attachSkills(params ?? const []);
  }
}
