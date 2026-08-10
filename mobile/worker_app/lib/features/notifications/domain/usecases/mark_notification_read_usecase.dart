import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

/// Marks a single notification (by id) as read via
/// `POST /api/notifications/{id}/mark-as-read`. Success carries no payload —
/// the bloc flips the local `is_read` flag itself.
class MarkNotificationReadUseCase
    implements UseCase<Either<Failure, Unit>, String> {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({String? params}) {
    return repository.markAsRead(params!);
  }
}
