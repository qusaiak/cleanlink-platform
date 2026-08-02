import '../entities/app_notification_entity.dart';
import '../../../../core/pagination/paginated_result.dart';

abstract class NotificationsRepository {
  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceType,
    required String lang,
  });

  Future<PaginatedResult<AppNotificationEntity>> getNotifications({
    required int page,
    required int perPage,
  });

  Future<int> getUnreadNotificationsCount();

  Future<AppNotificationEntity> markNotificationAsRead({
    required int notificationId,
  });
}
