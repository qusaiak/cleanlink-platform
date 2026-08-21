import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/login_client_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
