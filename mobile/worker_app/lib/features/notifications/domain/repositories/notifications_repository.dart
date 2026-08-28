import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsPageResult>> getNotifications({
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, Unit>> markAsRead(String id);

  Future<Either<Failure, List<AppNotification>>> markAllAsRead();
}
