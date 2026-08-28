import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsParams {
  final int page;
  final int perPage;

  const GetNotificationsParams({this.page = 1, this.perPage = 20});
}

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, NotificationsPageResult>> call({
    GetNotificationsParams params = const GetNotificationsParams(),
  }) {
    return repository.getNotifications(
      page: params.page,
      perPage: params.perPage,
    );
  }
}
