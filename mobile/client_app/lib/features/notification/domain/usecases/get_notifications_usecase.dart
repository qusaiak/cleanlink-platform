import '../entities/app_notification_entity.dart';
import '../repositories/notification_repo.dart';
import '../../../../core/pagination/paginated_result.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repo;

  const GetNotificationsUseCase(this.repo);

  Future<PaginatedResult<AppNotificationEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repo.getNotifications(page: page, perPage: perPage);
  }
}
