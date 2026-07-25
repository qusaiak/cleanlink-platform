import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task_stats.dart';
import 'task_model.dart';

/// Data-layer representation of [DailyTasks]: the header [TaskStats] plus the
/// list of [TaskModel]s, with JSON parsing for the "load my day" endpoint.
class DailyTasksModel extends DailyTasks {
  const DailyTasksModel({required super.stats, required super.tasks});

  factory DailyTasksModel.fromJson(Map<String, dynamic> json) {
    final statsJson = (json['stats'] ?? const {}) as Map<String, dynamic>;
    final tasksJson = (json['tasks'] ?? const []) as List;

    return DailyTasksModel(
      stats: TaskStats(
        remainingToday:
            (statsJson['remainingToday'] ?? statsJson['remaining_today'] ?? 0)
                as int,
        completed: (statsJson['completed'] ?? 0) as int,
        total: (statsJson['total'] ?? 0) as int,
      ),
      tasks: tasksJson
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
