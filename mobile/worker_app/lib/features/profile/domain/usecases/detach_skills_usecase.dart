import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Detaches skills from the worker (`DELETE /api/worker/detach-skills`).
///
/// The mirror image of [AttachSkillsUseCase]: only the ids being removed are
/// sent, and the response returns the full updated worker.
class DetachSkillsUseCase
    implements UseCase<Either<Failure, WorkerProfile>, List<int>> {
  final WorkerProfileRepository repository;

  DetachSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({List<int>? params}) {
    return repository.detachSkills(params ?? const []);
  }
}
