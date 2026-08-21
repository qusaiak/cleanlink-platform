import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'api_error_parser.dart';

class ErrorCode {
  static const String connectionTimeout = 'CONNECTION_TIMEOUT';
  static const String sendTimeout = 'SEND_TIMEOUT';
  static const String receiveTimeout = 'RECEIVE_TIMEOUT';
  static const String noInternet = 'NO_INTERNET';

  static const String badResponseFormat = 'BAD_RESPONSE_FORMAT';

  static const String tlsHandshakeFailed = 'TLS_HANDSHAKE_FAILED';

  static const String emptyCredentials = 'EMPTY_CREDENTIALS';

  static const String invalidStatusTransition = 'INVALID_STATUS_TRANSITION';

  static const String imagesOnlyWhenDone = 'IMAGES_ONLY_WHEN_DONE';

  static const String manualBusyNotAllowed = 'MANUAL_BUSY_NOT_ALLOWED';
}

abstract class Failure extends Equatable {
  final String message;
  final String errorCode;

  const Failure(this.message, this.errorCode);

  bool get isConnectionTimeout => errorCode == ErrorCode.connectionTimeout;
  bool get isSendTimeout => errorCode == ErrorCode.sendTimeout;
  bool get isReceiveTimeout => errorCode == ErrorCode.receiveTimeout;
  bool get isTimeout =>
      isConnectionTimeout || isSendTimeout || isReceiveTimeout;

  @override
  List<Object> get props => [message, errorCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, super.errorCode);

  factory ServerFailure.fromDioError(DioException e) {
    log(
      'DioException ${e.type} on ${e.requestOptions.method} '
      '${e.requestOptions.uri}\n'
      '  status : ${e.response?.statusCode ?? '— no response, host not reached'}\n'
      '  cause  : ${e.error?.runtimeType ?? 'none'} — ${e.error ?? e.message}',
      name: 'Network',
    );

    final underlying = e.error;
    if (underlying is SocketException) {
      log(
        'DioException wraps SocketException: ${underlying.message} '
        '(address=${underlying.address?.host}:${underlying.port}, '
        'osError=${underlying.osError})',
      );
      return const ServerFailure(
        'No Internet Connection',
        ErrorCode.noInternet,
      );
    }
    if (underlying is HandshakeException) {
      log('DioException wraps HandshakeException: ${underlying.message}');
      return const ServerFailure(
        'TLS handshake failed with api server',
        ErrorCode.tlsHandshakeFailed,
      );
    }
    if (underlying is TimeoutException) {
      log('DioException wraps TimeoutException: ${underlying.message}');
      return const ServerFailure(
        'Connection timeout with api server',
        ErrorCode.connectionTimeout,
      );
    }
    if (underlying is FormatException) {
      log(
        'DioException wraps FormatException: ${underlying.message} '
        '→ ${e.response?.data}',
      );
      return ServerFailure(
        parseApiError(e.response?.data),
        ErrorCode.badResponseFormat,
      );
    }

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
      case DioExceptionType.transformTimeout:
        return const ServerFailure(
          'Transform timeout with ApiServer',
          ErrorCode.receiveTimeout,
        );
      case DioExceptionType.badCertificate:
        return const ServerFailure('badCertificate with api server', "");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          e.response?.data,
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerFailure('Request to ApiServer was canceld', "");
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

  factory ServerFailure.fromResponse(dynamic response, {int? statusCode}) {
    final code = response is Map
        ? (response['ErrorCode'] ?? response['status'] ?? statusCode)
                  ?.toString() ??
              ''
        : statusCode?.toString() ?? '';

    return ServerFailure(parseApiError(response), code);
  }

  @override
  String toString() {
    return 'ServerFailure{errorMessage: $message}';
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, super.errorCode);

  @override
  String toString() {
    return 'ValidationFailure{errorMessage: $message}';
  }
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message, super.errorCode);

  @override
  String toString() {
    return 'ConnectionFailure{errorMessage: $message}';
  }
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, super.errorCode);
}

class PlaybackFailure extends Failure {
  const PlaybackFailure(super.message, super.errorCode);
}
