import '../entities/daily_tasks.dart';
import '../repositories/tasks_repository.dart';

class WatchDailyTasksUseCase {
  final TasksRepository repository;

  WatchDailyTasksUseCase(this.repository);

  Stream<DailyTasks> call() => repository.watchDailyTasks();
}
