// Hide dartz's own `Task` so it doesn't clash with our domain [Task] entity.
import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failure.dart';
import '../entities/daily_tasks.dart';
import '../entities/task.dart';

/// Contract for the tasks data source as seen by the domain layer.
///
/// Every method returns `Either<Failure, T>` (dartz) so call sites handle the
/// success/failure branches explicitly — matching the project's error model
/// built around [Failure] / `ServerFailure.fromDioError`.
abstract class TasksRepository {
  /// Loads the worker's tasks for the day together with the header stats.
  Future<Either<Failure, DailyTasks>> getDailyTasks();

  /// Loads a single task by its [id] (or request number). Used to open a task
  /// from a search result or a notification, which only carry an identifier.
  Future<Either<Failure, Task>> getTaskById(String id);

  /// Moves a task to a new [status] (start, pause, complete, on-the-way, …)
  /// and returns the updated task as confirmed by the backend.
  Future<Either<Failure, Task>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  });

  /// Uploads the "before"/"after" documentation photos for a task and returns
  /// the updated task. Used by the task-detail screen.
  Future<Either<Failure, Task>> uploadTaskPhotos({
    required String taskId,
    required List<String> beforePaths,
    required List<String> afterPaths,
  });
}
