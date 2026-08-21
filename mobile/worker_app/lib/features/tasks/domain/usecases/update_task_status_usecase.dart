import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskStatusParams extends Equatable {
  final String taskId;
  final TaskStatus currentStatus;
  final TaskStatus newStatus;
  final String? imageBeforePath;
  final String? imageAfterPath;

  const UpdateTaskStatusParams({
    required this.taskId,
    required this.currentStatus,
    required this.newStatus,
    this.imageBeforePath,
    this.imageAfterPath,
  });

  @override
  List<Object?> get props => [
    taskId,
    currentStatus,
    newStatus,
    imageBeforePath,
    imageAfterPath,
  ];
}

class UpdateTaskStatusUseCase
    implements UseCase<Either<Failure, Task>, UpdateTaskStatusParams> {
  final TasksRepository repository;

  UpdateTaskStatusUseCase(this.repository);

  @override
  Future<Either<Failure, Task>> call({UpdateTaskStatusParams? params}) async {
    final p = params!;

    if (!p.currentStatus.canAdvanceTo(p.newStatus)) {
      return const Left(
        ValidationFailure(
          'Task statuses must advance one step at a time '
          '(pending → on_way → handling → done); going backward or skipping '
          'is not allowed.',
          ErrorCode.invalidStatusTransition,
        ),
      );
    }

    final hasImages = p.imageBeforePath != null || p.imageAfterPath != null;
    if (hasImages && p.newStatus != TaskStatus.completed) {
      return const Left(
        ValidationFailure(
          'Before/after images may only be uploaded when marking the task '
          'as done.',
          ErrorCode.imagesOnlyWhenDone,
        ),
      );
    }

    return repository.updateTaskStatus(
      taskId: p.taskId,
      status: p.newStatus,
      imageBeforePath: p.imageBeforePath,
      imageAfterPath: p.imageAfterPath,
    );
  }
}
