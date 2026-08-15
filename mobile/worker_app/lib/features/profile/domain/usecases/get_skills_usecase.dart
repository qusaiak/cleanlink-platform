import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Loads the full catalogue of assignable skills (`GET /api/skills`), used to
/// populate the profile's "add skill" dropdown.
class GetSkillsUseCase
    implements UseCase<Either<Failure, List<WorkerSkill>>, NoParams> {
  final WorkerProfileRepository repository;

  GetSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WorkerSkill>>> call({NoParams? params}) {
    return repository.getAllSkills();
  }
}
