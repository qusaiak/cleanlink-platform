import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase
    implements UseCase<Either<Failure, Unit>, String> {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({String? params}) {
    return repository.markAsRead(params!);
  }
}
