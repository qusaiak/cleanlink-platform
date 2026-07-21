import 'package:equatable/equatable.dart';

import '../entities/app_notification_entity.dart';
import '../repositories/notification_repo.dart';

class MarkNotificationAsReadUseCase {
  final NotificationsRepository repo;

  const MarkNotificationAsReadUseCase(this.repo);

  Future<AppNotificationEntity> call(MarkNotificationAsReadParams params) {
    return repo.markNotificationAsRead(notificationId: params.notificationId);
  }
}

class MarkNotificationAsReadParams extends Equatable {
  final int notificationId;

  const MarkNotificationAsReadParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
