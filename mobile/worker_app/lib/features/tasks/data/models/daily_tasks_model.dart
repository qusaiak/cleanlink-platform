import '../../domain/entities/daily_tasks.dart';
import 'task_model.dart';

class DailyTasksModel extends DailyTasks {
  const DailyTasksModel({required super.tasks});

  factory DailyTasksModel.fromJson(Map<String, dynamic> json) {
    final tasksJson = (json['data'] ?? json['tasks'] ?? const []) as List;
    final tasks = tasksJson
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return DailyTasksModel(tasks: tasks);
  }
}
