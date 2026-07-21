import '../repositories/notification_repo.dart';

class GetUnreadNotificationsCountUseCase {
  final NotificationsRepository repo;

  const GetUnreadNotificationsCountUseCase(this.repo);

  Future<int> call() {
    return repo.getUnreadNotificationsCount();
  }
}
