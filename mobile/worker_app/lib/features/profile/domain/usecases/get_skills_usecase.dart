import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class GetSkillsUseCase
    implements UseCase<Either<Failure, List<WorkerSkill>>, NoParams> {
  final WorkerProfileRepository repository;

  GetSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WorkerSkill>>> call({NoParams? params}) {
    return repository.getAllSkills();
  }
}
