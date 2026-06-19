import 'package:dio/dio.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../models/app_notification_model.dart';

/// Remote data source contract for the notifications feature.
///
/// Implementations talk to the network and either return a model or throw a
/// [DioException] on failure; the repository turns those into
/// `Either<Failure, T>`. Three implementations are provided:
///  - [NotificationsRemoteDataSourceImpl]  — real Dio calls (production path).
///  - `FakeNotificationsRemoteDataSource`   — in-memory mock used today.
///  - `FallbackNotificationsRemoteDataSource` — live-with-fallback wrapper.
abstract class NotificationsRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications();

  Future<AppNotificationModel> markAsRead(String id);

  Future<List<AppNotificationModel>> markAllAsRead();
}

/// Real implementation backed by the shared [Dio] client (production path).
/// Swap the fake source for this in `injection_container.dart` once the backend
/// base URL is configured (already wired via the fallback source).
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSourceImpl(this.dio);

  List<AppNotificationModel> _parseList(dynamic data) {
    // Accept either a bare list or `{ "notifications": [...] }`.
    final list = data is Map<String, dynamic>
        ? (data['notifications'] ?? data['data'] ?? const [])
        : data;
    return (list as List)
        .map((e) => AppNotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    final response = await dio.get(ApiUrlParameters.notifications);
    return _parseList(response.data);
  }

  @override
  Future<AppNotificationModel> markAsRead(String id) async {
    final response = await dio.patch(ApiUrlParameters.markNotificationRead(id));
    return AppNotificationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<AppNotificationModel>> markAllAsRead() async {
    final response =
        await dio.patch(ApiUrlParameters.markAllNotificationsRead);
    return _parseList(response.data);
  }
}
