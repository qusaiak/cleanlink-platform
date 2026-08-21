import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failure.dart';
import '../entities/daily_tasks.dart';
import '../entities/task.dart';
import '../entities/today_task_summary.dart';

abstract class TasksRepository {
  Stream<DailyTasks> watchDailyTasks();

  Future<Either<Failure, DailyTasks>> getDailyTasks();

  Future<Either<Failure, TodayTaskSummary>> getTodayTaskSummary();

  Future<Either<Failure, Task>> getTaskById(String id);

  Future<Either<Failure, Task>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  });
}
