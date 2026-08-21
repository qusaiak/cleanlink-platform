import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  Future<Either<Failure, Unit>> markAsRead(String id);

  Future<Either<Failure, List<AppNotification>>> markAllAsRead();
}
