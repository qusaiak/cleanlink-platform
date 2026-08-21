import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class GetTaskByIdUseCase implements UseCase<Either<Failure, Task>, String> {
  final TasksRepository repository;

  GetTaskByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Task>> call({String? params}) {
    return repository.getTaskById(params ?? '');
  }
}
