import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repo.dart';

class LogoutUsecase implements UseCase<Either<Failure, Unit>, NoParams> {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({NoParams? params}) {
    return repository.logout();
  }
}
