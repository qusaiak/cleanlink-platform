import '../entities/app_notification_entity.dart';
import '../repositories/notification_repo.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repo;

  const GetNotificationsUseCase(this.repo);

  Future<List<AppNotificationEntity>> call() {
    return repo.getNotifications();
  }
}
