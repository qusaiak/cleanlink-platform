import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';

/// Domain contract for the worker's notification feed. Returns
/// `Either<Failure, T>` consistent with the rest of the app.
abstract class NotificationsRepository {
  /// All notifications, newest first.
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  /// Marks a single notification read; returns the updated notification.
  Future<Either<Failure, AppNotification>> markAsRead(String id);

  /// Marks every notification read; returns the updated list.
  Future<Either<Failure, List<AppNotification>>> markAllAsRead();
}
