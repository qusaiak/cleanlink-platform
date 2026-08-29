import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

enum AppFailureType {
  noInternet,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  server,
  cancelled,
  invalidUserRole,
  unknown,
}

// Error codes for specific failure types
class ErrorCode {
  static const String connectionTimeout = 'CONNECTION_TIMEOUT';
  static const String sendTimeout = 'SEND_TIMEOUT';
  static const String receiveTimeout = 'RECEIVE_TIMEOUT';
  static const String noInternet = 'NO_INTERNET';
}

abstract class Failure extends Equatable {
  final String message;
  final String errorCode;
  final Map<String, String> fieldErrors;

  const Failure(
    this.message,
    this.errorCode, {
    this.fieldErrors = const <String, String>{},
  });

  bool get isConnectionTimeout => errorCode == ErrorCode.connectionTimeout;
  bool get isSendTimeout => errorCode == ErrorCode.sendTimeout;
  bool get isReceiveTimeout => errorCode == ErrorCode.receiveTimeout;
  bool get isTimeout =>
      isConnectionTimeout || isSendTimeout || isReceiveTimeout;

  AppFailureType get type {
    if (errorCode == ErrorCode.noInternet) return AppFailureType.noInternet;
    if (isTimeout) return AppFailureType.timeout;
    return switch (errorCode) {
      '401' => AppFailureType.unauthorized,
      '403' => AppFailureType.forbidden,
      '404' => AppFailureType.notFound,
      '422' => AppFailureType.validation,
      '409' || 'BOOKING_CONFLICT' => AppFailureType.conflict,
      'CANCELLED' => AppFailureType.cancelled,
      '500' || '502' || '503' || '504' => AppFailureType.server,
      _ => AppFailureType.unknown,
    };
  }

  @override
  List<Object> get props => [message, errorCode, fieldErrors];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, super.errorCode, {super.fieldErrors});

  factory ServerFailure.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          'Connection timeout with api server',
          ErrorCode.connectionTimeout,
        );
      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          'Send timeout with ApiServer',
          ErrorCode.sendTimeout,
        );
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          'Receive timeout with ApiServer',
          ErrorCode.receiveTimeout,
        );
      case DioExceptionType.badCertificate:
        return const ServerFailure('badCertificate with api server', "");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(e.response!.data);
      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled', 'CANCELLED');
      case DioExceptionType.connectionError:
        return const ServerFailure(
          'No Internet Connection',
          ErrorCode.noInternet,
        );
      case DioExceptionType.unknown:
        return const ServerFailure(
          'Ops, There was an Error, Please try again',
          "",
        );
    }
  }

  factory ServerFailure.fromResponse(dynamic response) {
    if (response['ErrorMessage'] != null) {
      return ServerFailure(
        response['ErrorMessage'],
        response['ErrorCode'].toString(),
      );
    } else {
      return const ServerFailure('There was an error , please try again', "");
    }
  }

  @override
  String toString() {
    return 'ServerFailure{errorMessage: $message}';
  }
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message, super.errorCode);

  @override
  String toString() {
    return 'ConnectionFailure{errorMessage: $message}';
  }
}

class BookingConflictFailure extends Failure {
  const BookingConflictFailure(String message)
    : super(message, 'BOOKING_CONFLICT');

  @override
  AppFailureType get type => AppFailureType.conflict;
}

class InvalidUserRoleFailure extends Failure {
  final String actualRole;

  const InvalidUserRoleFailure(this.actualRole)
    : super('Account role is not allowed in this application', 'INVALID_ROLE');

  @override
  AppFailureType get type => AppFailureType.invalidUserRole;

  @override
  List<Object> get props => [...super.props, actualRole];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, super.errorCode);
}

class PlaybackFailure extends Failure {
  const PlaybackFailure(super.message, super.errorCode);
}
