import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_stats.dart';
import 'task_model.dart';

/// Data-layer representation of [DailyTasks]: the header [TaskStats] plus the
/// list of [TaskModel]s, with JSON parsing for the "load my day" endpoint.
class DailyTasksModel extends DailyTasks {
  const DailyTasksModel({required super.stats, required super.tasks});

  /// Parses either the flat mock contract (`{stats: {...}, tasks: [...]}`) or
  /// the real `GET /api/tasks` response envelope
  /// (`{status, message, data: [...worker task logs]}`), deriving the summary
  /// stats from the list itself when the backend doesn't send them.
  factory DailyTasksModel.fromJson(Map<String, dynamic> json) {
    final tasksJson = (json['data'] ?? json['tasks'] ?? const []) as List;
    final tasks = tasksJson
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final statsJson = json['stats'] as Map<String, dynamic>?;
    if (statsJson != null) {
      return DailyTasksModel(
        stats: TaskStats(
          remainingToday:
              (statsJson['remainingToday'] ?? statsJson['remaining_today'] ?? 0)
                  as int,
          completed: (statsJson['completed'] ?? 0) as int,
          total: (statsJson['total'] ?? 0) as int,
        ),
        tasks: tasks,
      );
    }

    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final remaining = tasks
        .where(
          (t) =>
              t.status != TaskStatus.completed &&
              t.status != TaskStatus.cancelled,
        )
        .length;

    return DailyTasksModel(
      stats: TaskStats(
        remainingToday: remaining,
        completed: completed,
        total: tasks.length,
      ),
      tasks: tasks,
    );
  }
}
