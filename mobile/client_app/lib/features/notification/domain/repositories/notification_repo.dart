import '../entities/app_notification_entity.dart';

abstract class NotificationsRepository {
  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceType,
    required String lang,
  });

  Future<List<AppNotificationEntity>> getNotifications();

  Future<int> getUnreadNotificationsCount();

  Future<AppNotificationEntity> markNotificationAsRead({
    required int notificationId,
  });
}
