import 'package:dio/dio.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/task.dart';
import '../models/daily_tasks_model.dart';
import '../models/task_model.dart';

/// Remote data source contract for the tasks feature.
///
/// Implementations talk to the network and either return a model or throw a
/// [DioException] on failure; the repository is responsible for turning those
/// into `Either<Failure, T>`. Two implementations are provided:
///  - [TasksRemoteDataSourceImpl]  — real Dio calls (wired when the API exists).
///  - `FakeTasksRemoteDataSource`   — in-memory mock used today.
abstract class TasksRemoteDataSource {
  Future<DailyTasksModel> getDailyTasks();

  /// Fetches a single task by its [id] (or its human-facing request number).
  /// Used to open a task from a search result or a notification.
  Future<TaskModel> getTaskById(String id);

  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  });

  Future<TaskModel> uploadTaskPhotos({
    required String taskId,
    required List<String> beforePaths,
    required List<String> afterPaths,
  });
}

/// Real implementation backed by the shared [Dio] client.
///
/// This is the production path. It is intentionally kept simple (plain Dio
/// instead of retrofit codegen) so it compiles without `build_runner` and so
/// the endpoints in [ApiUrlParameters] can be filled in later without a
/// generation step. Swap [FakeTasksRemoteDataSource] for this in
/// `injection_container.dart` once the backend base URL is configured.
class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Dio dio;

  TasksRemoteDataSourceImpl(this.dio);

  @override
  Future<DailyTasksModel> getDailyTasks() async {
    final response = await dio.get(ApiUrlParameters.dailyTasks);
    return DailyTasksModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    final response = await dio.get(ApiUrlParameters.taskById(id));
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    final response = await dio.patch(
      ApiUrlParameters.taskStatus(taskId),
      data: {'status': TaskModel.statusCode(status)},
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TaskModel> uploadTaskPhotos({
    required String taskId,
    required List<String> beforePaths,
    required List<String> afterPaths,
  }) async {
    final formData = FormData.fromMap({
      'before': [
        for (final p in beforePaths) await MultipartFile.fromFile(p),
      ],
      'after': [
        for (final p in afterPaths) await MultipartFile.fromFile(p),
      ],
    });
    final response = await dio.post(
      ApiUrlParameters.taskPhotos(taskId),
      data: formData,
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }
}
