import 'package:dio/dio.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/notification_repo.dart';
import '../data_sources/fcm_service.dart';
import '../models/update_fcm_token_request_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsApiService api;

  const NotificationsRepositoryImpl(this.api);

  @override
  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceType,
    required String lang,
  }) async {
    try {
      await api.updateFcmToken(
        UpdateFcmTokenRequestModel(
          fcmToken: fcmToken,
          deviceType: deviceType,
          lang: lang,
        ),
      );
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<List<AppNotificationEntity>> getNotifications() async {
    try {
      final response = await api.getNotifications();
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    try {
      final response = await api.getUnreadNotificationsCount();
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<AppNotificationEntity> markNotificationAsRead({
    required int notificationId,
  }) async {
    try {
      final response = await api.markAsRead(notificationId);
      return response.data.data?.toEntity() ??
          AppNotificationEntity(
            id: notificationId,
            title: '',
            body: '',
            isRead: true,
          );
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }
}
