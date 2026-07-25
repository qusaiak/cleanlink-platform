// Hide dartz's own `Task` so it doesn't clash with our domain [Task] entity.
import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

/// Parameters for [UploadTaskPhotosUseCase].
class UploadTaskPhotosParams extends Equatable {
  final String taskId;
  final List<String> beforePaths;
  final List<String> afterPaths;

  const UploadTaskPhotosParams({
    required this.taskId,
    required this.beforePaths,
    required this.afterPaths,
  });

  @override
  List<Object?> get props => [taskId, beforePaths, afterPaths];
}

/// Uploads the before/after documentation photos for a task (task-detail
/// screen) and returns the updated task.
class UploadTaskPhotosUseCase
    implements UseCase<Either<Failure, Task>, UploadTaskPhotosParams> {
  final TasksRepository repository;

  UploadTaskPhotosUseCase(this.repository);

  @override
  Future<Either<Failure, Task>> call({UploadTaskPhotosParams? params}) {
    return repository.uploadTaskPhotos(
      taskId: params!.taskId,
      beforePaths: params.beforePaths,
      afterPaths: params.afterPaths,
    );
  }
}
