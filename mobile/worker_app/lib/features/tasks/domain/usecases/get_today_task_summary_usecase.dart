import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/today_task_summary.dart';
import '../repositories/tasks_repository.dart';

class GetTodayTaskSummaryUseCase {
  final TasksRepository repository;

  const GetTodayTaskSummaryUseCase(this.repository);

  Future<Either<Failure, TodayTaskSummary>> call() =>
      repository.getTodayTaskSummary();
}
