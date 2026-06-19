import 'package:dio/dio.dart';

import '../../domain/entities/task.dart';
import '../models/daily_tasks_model.dart';
import '../models/task_model.dart';
import 'tasks_remote_data_source.dart';

/// A [TasksRemoteDataSource] that prefers live data from the backend/database
/// but transparently falls back to the current in-memory data when the server
/// is not reachable.
///
/// Behaviour:
///  - When there IS a connection and the backend (and its database) is running,
///    every call goes to [primary] — the real Dio implementation — so the UI
///    shows live data straight from the database.
///  - When the server is unreachable (offline, connection refused/timeout, host
///    not found, …) the call is served by [fallback] — the in-memory mock — so
///    the data simply stays as it is today instead of erroring out.
///
/// A request that DOES reach the server but comes back with an HTTP error is
/// left to propagate: the server is running, so the error is real and should be
/// surfaced rather than masked by mock data.
class FallbackTasksRemoteDataSource implements TasksRemoteDataSource {
  /// Real Dio-backed source (POST/GET against the backend → database).
  final TasksRemoteDataSource primary;

  /// In-memory source used when the backend can't be reached.
  final TasksRemoteDataSource fallback;

  FallbackTasksRemoteDataSource({
    required this.primary,
    required this.fallback,
  });

  /// True when [e] indicates the server could not be reached at all (as opposed
  /// to a server that replied with an error status).
  bool _isServerUnreachable(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.unknown:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return false;
    }
  }

  /// Runs [live] against the backend; on an unreachable server, runs [offline].
  Future<T> _preferLive<T>(
    Future<T> Function() live,
    Future<T> Function() offline,
  ) async {
    try {
      return await live();
    } on DioException catch (e) {
      if (_isServerUnreachable(e)) return await offline();
      rethrow;
    }
  }

  @override
  Future<DailyTasksModel> getDailyTasks() =>
      _preferLive(primary.getDailyTasks, fallback.getDailyTasks);

  @override
  Future<TaskModel> getTaskById(String id) =>
      _preferLive(() => primary.getTaskById(id), () => fallback.getTaskById(id));

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) => _preferLive(
    () => primary.updateTaskStatus(taskId: taskId, status: status),
    () => fallback.updateTaskStatus(taskId: taskId, status: status),
  );

  @override
  Future<TaskModel> uploadTaskPhotos({
    required String taskId,
    required List<String> beforePaths,
    required List<String> afterPaths,
  }) => _preferLive(
    () => primary.uploadTaskPhotos(
      taskId: taskId,
      beforePaths: beforePaths,
      afterPaths: afterPaths,
    ),
    () => fallback.uploadTaskPhotos(
      taskId: taskId,
      beforePaths: beforePaths,
      afterPaths: afterPaths,
    ),
  );
}
