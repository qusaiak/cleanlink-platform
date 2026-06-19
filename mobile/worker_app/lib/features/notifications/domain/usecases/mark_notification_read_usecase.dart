import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

/// Marks a single notification (by id) as read.
class MarkNotificationReadUseCase
    implements UseCase<Either<Failure, AppNotification>, String> {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, AppNotification>> call({String? params}) {
    return repository.markAsRead(params!);
  }
}
