import '../entities/daily_tasks.dart';
import '../repositories/tasks_repository.dart';

/// Streams the worker's day from the single source of truth (the repository
/// cache), emitting whenever it changes — after a load or any status update,
/// from any screen. The bloc subscribes so the list rebuilds on its own.
class WatchDailyTasksUseCase {
  final TasksRepository repository;

  WatchDailyTasksUseCase(this.repository);

  Stream<DailyTasks> call() => repository.watchDailyTasks();
}
