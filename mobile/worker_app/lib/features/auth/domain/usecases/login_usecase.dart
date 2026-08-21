import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_client_entity.dart';
import '../repositories/auth_repo.dart';

class LoginUsecase extends UseCase<Either<Failure, LoginEntity>, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, LoginEntity>> call({LoginParams? params}) {
    final email = params?.email.trim() ?? '';
    final password = params?.password ?? '';

    if (email.isEmpty || password.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(
            'Email and password are required',
            ErrorCode.emptyCredentials,
          ),
        ),
      );
    }

    return repository.login(email: email, password: password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
