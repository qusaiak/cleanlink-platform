import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
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
  }) =>
      _guard('login', () => apiService.login(email: email, password: password));

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

  /// Runs [action] and maps every failure mode onto a distinct [Failure],
  /// LOGGING the real cause (with its stack) on the way out.
  ///
  /// Each `catch` is deliberately specific, and none of them swallows anything:
  ///  - [DioException]  → the server's own message when it answered, or a
  ///    transport code when it never did (see `ServerFailure.fromDioError`).
  ///  - [SocketException]  → no route to the host / connection refused. This is
  ///    what a backend that isn't running looks like.
  ///  - [TimeoutException] → a timeout raised outside Dio's own machinery.
  ///  - [FormatException]  → the body could not be read as JSON.
  ///  - anything else → reported as-is rather than hidden behind a generic
  ///    string, so an unexpected bug is still visible in the message and log.
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
