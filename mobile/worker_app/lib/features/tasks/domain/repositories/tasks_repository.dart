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
  /// The single source of truth for the worker's day: emits the cached
  /// [DailyTasks] whenever it changes — after a load or any status update,
  /// from any screen. Every task-status write funnels through this repository,
  /// so listeners (the list) rebuild without screen-to-screen propagation.
  Stream<DailyTasks> watchDailyTasks();

  /// Loads the worker's tasks for the day together with the header stats.
  /// Also refreshes and emits on [watchDailyTasks].
  Future<Either<Failure, DailyTasks>> getDailyTasks();

  /// Loads a single task by its [id] (or request number). Used to open a task
  /// from a search result or a notification, which only carry an identifier.
  Future<Either<Failure, Task>> getTaskById(String id);

  /// Advances a task to [status], optionally attaching the before/after
  /// documentation photos (only legal when [status] is `done`), and returns
  /// the updated task as confirmed by the backend.
  Future<Either<Failure, Task>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  });
}
