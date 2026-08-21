import 'package:dio/dio.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/task.dart';
import '../models/daily_tasks_model.dart';
import '../models/task_model.dart';
import '../models/today_task_summary_model.dart';

abstract class TasksRemoteDataSource {
  Future<DailyTasksModel> getDailyTasks();

  Future<TodayTaskSummaryModel> getTodayTaskSummary();

  Future<TaskModel> getTaskById(String id);

  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  });
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Dio dio;

  TasksRemoteDataSourceImpl(this.dio);

  @override
  Future<DailyTasksModel> getDailyTasks() async {
    final response = await dio.get(ApiUrlParameters.dailyTasks);
    return DailyTasksModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TodayTaskSummaryModel> getTodayTaskSummary() async {
    final response = await dio.get(ApiUrlParameters.todayTaskSummary);
    return TodayTaskSummaryModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    final response = await dio.get(ApiUrlParameters.taskById(id));
    final body = response.data as Map<String, dynamic>;
    return TaskModel.fromJson(_unwrapData(body), idOverride: id);
  }

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    String? imageBeforePath,
    String? imageAfterPath,
  }) async {
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

  Map<String, dynamic> _unwrapData(Map<String, dynamic> body) =>
      (body['data'] as Map<String, dynamic>?) ?? body;
}
