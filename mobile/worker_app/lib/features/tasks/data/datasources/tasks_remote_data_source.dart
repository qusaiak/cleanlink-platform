import 'package:dio/dio.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/task.dart';
import '../models/daily_tasks_model.dart';
import '../models/task_model.dart';

/// Remote data source contract for the tasks feature.
///
/// Implementations talk to the network and either return a model or throw a
/// [DioException] on failure; the repository is responsible for turning those
/// into `Either<Failure, T>`.
abstract class TasksRemoteDataSource {
  Future<DailyTasksModel> getDailyTasks();

  /// Fetches a single task by its [id] (or its human-facing request number).
  /// Used to open a task from a search result or a notification.
  Future<TaskModel> getTaskById(String id);

  /// Advances a task to [status]. [imageBeforePath]/[imageAfterPath] are local
  /// file paths for the before/after documentation photos — the contract only
  /// accepts them when [status] is `done` (enforced upstream by
  /// `UpdateTaskStatusUseCase` before this is ever called).
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  });
}

/// Real implementation backed by the shared [Dio] client.
///
/// This is the production path. It is intentionally kept simple (plain Dio
/// instead of retrofit codegen) so it compiles without `build_runner` and so
/// the endpoints in [ApiUrlParameters] can be filled in later without a
/// generation step.
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
    try {
      final response = await dio.get(ApiUrlParameters.taskById(id));
      final body = response.data as Map<String, dynamic>;
      return TaskModel.fromJson(_unwrapData(body), idOverride: id);
    } on DioException catch (e) {
      // Notifications (and some search results) only carry the *order id*
      // (`data.order_id`), but the detail endpoint resolves a task by its
      // `workgroup_id` — so an order id 404s. Map the order id to the task's
      // workgroup id via the daily list, then fetch the real detail by it so
      // the screen renders in full (the list copy alone lacks the company
      // image, which the list query doesn't load).
      if (e.response?.statusCode == 404) {
        final workgroupId = await _workgroupIdFor(id);
        if (workgroupId != null && workgroupId != id) {
          return getTaskById(workgroupId);
        }
      }
      rethrow;
    }
  }

  /// Resolves the task's API identifier (its `workgroup_id`, i.e. [Task.id] in
  /// this app) for a task addressed by [identifier] — its workgroup id or its
  /// order id ([Task.requestNumber]) — by scanning the worker's daily list.
  /// Returns `null` when the task isn't in today's set.
  Future<String?> _workgroupIdFor(String identifier) async {
    final daily = await getDailyTasks();
    for (final task in daily.tasks) {
      if (task.id == identifier || task.requestNumber == identifier) {
        return task.id;
      }
    }
    return null;
  }

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  }) async {
    // POST /api/tasks/{task_id}/update-status with
    // `{status, image_before, image_after}`. When photos ride along (only
    // ever at `done`) the body goes multipart so the files upload; otherwise
    // plain JSON with the image fields empty, exactly as the contract shows.
    final code = TaskModel.statusCode(status);
    final Object body;
    if (imageBeforePath != null || imageAfterPath != null) {
      body = FormData.fromMap({
        'status': code,
        'image_before': imageBeforePath == null
            ? ''
            : await MultipartFile.fromFile(imageBeforePath),
        'image_after': imageAfterPath == null
            ? ''
            : await MultipartFile.fromFile(imageAfterPath),
      });
    } else {
      body = {'status': code, 'image_before': '', 'image_after': ''};
    }

    final response = await dio.post(
      ApiUrlParameters.taskStatus(taskId),
      data: body,
    );
    final responseBody = response.data as Map<String, dynamic>;
    return TaskModel.fromJson(_unwrapData(responseBody), idOverride: taskId);
  }

  /// The real backend wraps every payload as `{status, message, data}`; this
  /// unwraps it while staying compatible with a flat (unwrapped) response.
  Map<String, dynamic> _unwrapData(Map<String, dynamic> body) =>
      (body['data'] as Map<String, dynamic>?) ?? body;
}
