import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/daily_tasks.dart';
import '../repositories/tasks_repository.dart';

/// Loads the worker's daily tasks + stats. Takes [NoParams] since the backend
/// derives "today" and the worker from the auth token.
class GetDailyTasksUseCase
    implements UseCase<Either<Failure, DailyTasks>, NoParams> {
  final TasksRepository repository;

  GetDailyTasksUseCase(this.repository);

  @override
  Future<Either<Failure, DailyTasks>> call({NoParams? params}) {
    return repository.getDailyTasks();
  }
}
