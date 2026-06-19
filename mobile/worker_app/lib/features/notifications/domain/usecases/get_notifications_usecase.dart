import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

/// Loads the worker's notification feed. Takes [NoParams] since the backend
/// derives the worker from the auth token.
class GetNotificationsUseCase
    implements UseCase<Either<Failure, List<AppNotification>>, NoParams> {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppNotification>>> call({NoParams? params}) {
    return repository.getNotifications();
  }
}
