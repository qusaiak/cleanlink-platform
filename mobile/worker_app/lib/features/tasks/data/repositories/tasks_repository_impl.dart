import 'dart:async';

// Hide dartz's own `Task` so it doesn't clash with our domain [Task] entity.
import 'package:dartz/dartz.dart' hide Task;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_stats.dart';
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

  /// The single cached copy of the worker's day (registered as a singleton, so
  /// every screen shares it). Task status lives here and nowhere else.
  DailyTasks? _cache;

  /// Broadcasts the cache to every listener (the list) on each change.
  final StreamController<DailyTasks> _controller =
      StreamController<DailyTasks>.broadcast();

  @override
  Stream<DailyTasks> watchDailyTasks() => _controller.stream;

  /// Replaces the cache and notifies listeners.
  void _emit(DailyTasks daily) {
    _cache = daily;
    if (!_controller.isClosed) _controller.add(daily);
  }

  /// Returns [daily] with the task matching [updated]'s id refreshed and the
  /// header stats recomputed from the resulting list (same derivation the list
  /// load uses), so counters never drift. If the task isn't in the cache,
  /// [daily] is returned unchanged.
  ///
  /// Only the mutable fields of a status change ([updated]'s status and photos)
  /// are merged onto the already-loaded task — the rest of [updated] is
  /// discarded. This matters because the `update-status` response is a lighter
  /// object: it carries only the order's `client_id`, so its `customerName`
  /// comes back as the `Client #<id>` placeholder. Swapping the whole object in
  /// would clobber the real client name (and other display-only fields) that
  /// the full list load already resolved.
  DailyTasks _withTask(DailyTasks daily, Task updated) {
    final tasks = [
      for (final t in daily.tasks)
        t.id == updated.id ? _mergeStatus(t, updated) : t,
    ];
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
    return DailyTasks(
      stats: TaskStats(
        remainingToday: remaining,
        completed: completed,
        total: tasks.length,
      ),
      tasks: tasks,
    );
  }

  /// Applies only what a status update legitimately changes — the status and,
  /// when the `done` step uploaded them, the before/after photos — onto the
  /// [existing] cached task, preserving every already-loaded display field
  /// (notably the client name). Empty photo lists from the response are treated
  /// as "unchanged" so existing photos are never dropped.
  Task _mergeStatus(Task existing, Task updated) => existing.copyWith(
    status: updated.status,
    beforePhotos: updated.beforePhotos.isEmpty ? null : updated.beforePhotos,
    afterPhotos: updated.afterPhotos.isEmpty ? null : updated.afterPhotos,
  );

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
  Future<Either<Failure, DailyTasks>> getDailyTasks() async {
    final result = await _guard(() => remoteDataSource.getDailyTasks());
    // Loading fills the cache and notifies the list.
    result.fold((_) {}, _emit);
    return result;
  }

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
    // A confirmed status change writes to the single source of truth once;
    // every listener (the list) rebuilds — no matter which screen triggered
    // it (list, detail, in-app or FCM notification).
    result.fold((_) {}, (updated) {
      final current = _cache;
      if (current != null) _emit(_withTask(current, updated));
    });
    return result;
  }
}
