import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/login_client_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  });

  /// Logs the worker out on the server (`POST /api/auth/logout`). Local session
  /// clearing is handled by the caller regardless of the outcome.
  Future<Either<Failure, Unit>> logout();

  /// Changes the worker's password (`PUT /api/auth/change-password`).
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
