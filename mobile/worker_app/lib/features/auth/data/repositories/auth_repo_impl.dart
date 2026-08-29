import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/auth/user_role.dart';
import '../../domain/entities/login_client_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await _guard(
      'login',
      () => apiService.login(email: email, password: password),
    );
    return result.fold(
      Left.new,
      (entity) => UserRole.parse(entity.role) == UserRole.worker
          ? Right(entity)
          : Left(InvalidUserRoleFailure(entity.role)),
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() => _guard('logout', () async {
    await apiService.logout();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) => _guard('changePassword', () async {
    await apiService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
    return unit;
  });

  Future<Either<Failure, T>> _guard<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    try {
      return Right(await action());
    } on DioException catch (e, stack) {
      log(
        'auth.$operation failed: ${e.type} '
        'status=${e.response?.statusCode} body=${e.response?.data}',
        error: e,
        stackTrace: stack,
      );
      return Left(ServerFailure.fromDioError(e));
    } on SocketException catch (e, stack) {
      log('auth.$operation socket error', error: e, stackTrace: stack);
      return const Left(
        ServerFailure('No Internet Connection', ErrorCode.noInternet),
      );
    } on TimeoutException catch (e, stack) {
      log('auth.$operation timed out', error: e, stackTrace: stack);
      return const Left(
        ServerFailure(
          'Connection timeout with api server',
          ErrorCode.connectionTimeout,
        ),
      );
    } on FormatException catch (e, stack) {
      log('auth.$operation bad response format', error: e, stackTrace: stack);
      return const Left(
        ServerFailure(
          'Malformed response from api server',
          ErrorCode.badResponseFormat,
        ),
      );
    } catch (e, stack) {
      log('auth.$operation unexpected error', error: e, stackTrace: stack);
      return Left(ServerFailure(e.toString(), ''));
    }
  }
}
