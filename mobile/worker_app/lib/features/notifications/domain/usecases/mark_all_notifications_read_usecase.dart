import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase
    implements UseCase<Either<Failure, List<AppNotification>>, NoParams> {
  final NotificationsRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppNotification>>> call({NoParams? params}) {
    return repository.markAllAsRead();
  }
}
