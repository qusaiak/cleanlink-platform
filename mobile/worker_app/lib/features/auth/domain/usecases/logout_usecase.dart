import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repo.dart';

/// Logs the worker out on the server. A failure is returned (not thrown) so the
/// caller can still clear the local session and route to login either way — the
/// worker must never be left stuck signed in.
class LogoutUsecase implements UseCase<Either<Failure, Unit>, NoParams> {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({NoParams? params}) {
    return repository.logout();
  }
}
