// Hide dartz's own `Task` so it doesn't clash with our domain [Task] entity.
import 'package:dartz/dartz.dart' hide Task;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';

/// Concrete [TasksRepository]. It:
///  1. checks connectivity via [NetworkInfo] (returns a [ConnectionFailure]
///     with the project's `noInternet` code when offline);
///  2. delegates to the [TasksRemoteDataSource];
///  3. converts any [DioException] into a [ServerFailure] using the shared
///     `ServerFailure.fromDioError`, and any other error into a generic one.
///
/// This keeps the success/failure contract (`Either<Failure, T>`) consistent
/// with the rest of the app's error handling.
class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TasksRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Shared guard that runs [action] only when online and maps thrown errors
  /// to the appropriate [Failure].
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        ConnectionFailure('No Internet Connection', ErrorCode.noInternet),
      );
    }
    try {
      return Right(await action());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString(), ''));
    }
  }

  @override
  Future<Either<Failure, DailyTasks>> getDailyTasks() =>
      _guard(() => remoteDataSource.getDailyTasks());

  @override
  Future<Either<Failure, Task>> getTaskById(String id) =>
      _guard(() => remoteDataSource.getTaskById(id));

  @override
  Future<Either<Failure, Task>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) => _guard(
    () => remoteDataSource.updateTaskStatus(taskId: taskId, status: status),
  );

  @override
  Future<Either<Failure, Task>> uploadTaskPhotos({
    required String taskId,
    required List<String> beforePaths,
    required List<String> afterPaths,
  }) => _guard(
    () => remoteDataSource.uploadTaskPhotos(
      taskId: taskId,
      beforePaths: beforePaths,
      afterPaths: afterPaths,
    ),
  );
}
