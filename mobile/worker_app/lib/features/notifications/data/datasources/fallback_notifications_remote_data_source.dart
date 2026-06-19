import 'package:dio/dio.dart';

import '../models/app_notification_model.dart';
import 'notifications_remote_data_source.dart';

/// A [NotificationsRemoteDataSource] that prefers live data from the
/// backend/database but transparently falls back to the in-memory data when the
/// server is unreachable — mirroring `FallbackTasksRemoteDataSource`.
///
/// A request that DOES reach the server but returns an HTTP error is left to
/// propagate (the error is real and should be surfaced, not masked by mocks).
class FallbackNotificationsRemoteDataSource
    implements NotificationsRemoteDataSource {
  final NotificationsRemoteDataSource primary;
  final NotificationsRemoteDataSource fallback;

  FallbackNotificationsRemoteDataSource({
    required this.primary,
    required this.fallback,
  });

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
  Future<List<AppNotificationModel>> getNotifications() =>
      _preferLive(primary.getNotifications, fallback.getNotifications);

  @override
  Future<AppNotificationModel> markAsRead(String id) => _preferLive(
        () => primary.markAsRead(id),
        () => fallback.markAsRead(id),
      );

  @override
  Future<List<AppNotificationModel>> markAllAsRead() =>
      _preferLive(primary.markAllAsRead, fallback.markAllAsRead);
}
