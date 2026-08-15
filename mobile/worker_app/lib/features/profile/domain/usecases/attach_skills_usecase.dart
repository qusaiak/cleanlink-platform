import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Attaches skills the worker does not have yet
/// (`POST /api/worker/update-skills`).
///
/// Only the NEW ids are sent — this endpoint adds, it does not replace — and
/// the response returns the full updated worker, which the caller adopts as the
/// new source of truth.
class AttachSkillsUseCase
    implements UseCase<Either<Failure, WorkerProfile>, List<int>> {
  final WorkerProfileRepository repository;

  AttachSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({List<int>? params}) {
    return repository.attachSkills(params ?? const []);
  }
}
