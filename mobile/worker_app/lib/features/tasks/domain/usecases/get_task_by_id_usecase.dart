// Hide dartz's own `Task` so it doesn't clash with our domain [Task] entity.
import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

/// Loads a single [Task] by its id (or request number). Used to open the task
/// detail screen from a search result or a notification, which only carry an
/// identifier rather than the full task.
class GetTaskByIdUseCase implements UseCase<Either<Failure, Task>, String> {
  final TasksRepository repository;

  GetTaskByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Task>> call({String? params}) {
    return repository.getTaskById(params ?? '');
  }
}
