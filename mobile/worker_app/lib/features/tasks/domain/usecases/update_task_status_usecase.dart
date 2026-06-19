// Hide dartz's own `Task` so it doesn't clash with our domain [Task] entity.
import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

/// Parameters for [UpdateTaskStatusUseCase].
class UpdateTaskStatusParams extends Equatable {
  final String taskId;
  final TaskStatus status;

  const UpdateTaskStatusParams({required this.taskId, required this.status});

  @override
  List<Object?> get props => [taskId, status];
}

/// Transitions a task to a new lifecycle [status]. All worker actions
/// (start work, pause, complete, on-the-way…) funnel through here so the
/// status-change rules live in one place.
class UpdateTaskStatusUseCase
    implements UseCase<Either<Failure, Task>, UpdateTaskStatusParams> {
  final TasksRepository repository;

  UpdateTaskStatusUseCase(this.repository);

  @override
  Future<Either<Failure, Task>> call({UpdateTaskStatusParams? params}) {
    return repository.updateTaskStatus(
      taskId: params!.taskId,
      status: params.status,
    );
  }
}
