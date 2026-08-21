import 'dart:async';

import 'package:dartz/dartz.dart' hide Task;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/today_task_summary.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TasksRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  DailyTasks? _cache;

  final StreamController<DailyTasks> _controller =
      StreamController<DailyTasks>.broadcast();

  @override
  Stream<DailyTasks> watchDailyTasks() => _controller.stream;

  void _emit(DailyTasks daily) {
    _cache = daily;
    if (!_controller.isClosed) _controller.add(daily);
  }

  DailyTasks _withTask(DailyTasks daily, Task updated) {
    final tasks = [
      for (final t in daily.tasks)
        t.id == updated.id ? _mergeStatus(t, updated) : t,
    ];
    return DailyTasks(tasks: tasks);
  }

  Task _mergeStatus(Task existing, Task updated) => existing.copyWith(
    status: updated.status,
    beforePhotos: updated.beforePhotos.isEmpty ? null : updated.beforePhotos,
    afterPhotos: updated.afterPhotos.isEmpty ? null : updated.afterPhotos,
  );

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
  Future<Either<Failure, DailyTasks>> getDailyTasks() async {
    final result = await _guard(() => remoteDataSource.getDailyTasks());

    result.fold((_) {}, _emit);
    return result;
  }

  @override
  Future<Either<Failure, TodayTaskSummary>> getTodayTaskSummary() =>
      _guard(() => remoteDataSource.getTodayTaskSummary());

  @override
  Future<Either<Failure, Task>> getTaskById(String id) =>
      _guard(() => remoteDataSource.getTaskById(id));

  @override
  Future<Either<Failure, Task>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  }) async {
    final result = await _guard(
      () => remoteDataSource.updateTaskStatus(
        taskId: taskId,
        status: status,
        imageBeforePath: imageBeforePath,
        imageAfterPath: imageAfterPath,
      ),
    );

    result.fold((_) {}, (updated) {
      final current = _cache;
      if (current != null) _emit(_withTask(current, updated));
    });
    return result;
  }
}
