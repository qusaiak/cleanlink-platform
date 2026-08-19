import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'api_error_parser.dart';

// Error codes for specific failure types
class ErrorCode {
  static const String connectionTimeout = 'CONNECTION_TIMEOUT';
  static const String sendTimeout = 'SEND_TIMEOUT';
  static const String receiveTimeout = 'RECEIVE_TIMEOUT';
  static const String noInternet = 'NO_INTERNET';

  /// The server answered, but the body could not be read as the expected
  /// format (HTML error page, truncated JSON, …).
  static const String badResponseFormat = 'BAD_RESPONSE_FORMAT';

  /// The host was reached but the TLS handshake failed (self-signed or expired
  /// certificate, or an `https://` URL aimed at a plain-HTTP dev server).
  /// Deliberately distinct from [noInternet]: the network is fine.
  static const String tlsHandshakeFailed = 'TLS_HANDSHAKE_FAILED';

  /// A credential field was empty, caught before the request left the app.
  static const String emptyCredentials = 'EMPTY_CREDENTIALS';

  /// A task status change that is not the single next step of the strict
  /// `pending → on_way → handling → done` sequence (backward or skipping).
  static const String invalidStatusTransition = 'INVALID_STATUS_TRANSITION';

  /// Before/after images attached to a status other than `done`.
  static const String imagesOnlyWhenDone = 'IMAGES_ONLY_WHEN_DONE';

  /// An attempt to manually select the `busy` worker status (system-only).
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

  /// Maps a [DioException] onto a failure.
  ///
  /// Transport-level problems are separated from server-level ones, because
  /// only the latter carry a message the API wrote: a socket error or a timeout
  /// has no body to show, so it gets a stable code that the display layer turns
  /// into a localized local message. Everything that DID reach the server is
  /// routed through [parseApiError] so the API's own wording survives intact.
  factory ServerFailure.fromDioError(DioException e) {
    // One line that answers "could the device even REACH the host?" — the
    // question that separates a LAN/firewall/binding problem from a server
    // that answered with an error. The full URL matters: it is the only place
    // the host the device actually dialled is visible.
    log(
      'DioException ${e.type} on ${e.requestOptions.method} '
      '${e.requestOptions.uri}\n'
      '  status : ${e.response?.statusCode ?? '— no response, host not reached'}\n'
      '  cause  : ${e.error?.runtimeType ?? 'none'} — ${e.error ?? e.message}',
      name: 'Network',
    );

    // Dio wraps the real cause in `error`; inspect it first so a SocketException
    // arriving as `unknown`/`connectionError` is still reported as "no
    // connection" rather than a generic "try again".
    final underlying = e.error;
    if (underlying is SocketException) {
      // On a physical device this is almost always one of: the server bound to
      // 127.0.0.1 instead of 0.0.0.0, a firewall blocking the port, or the app
      // dialling an emulator/loopback host. `osError` carries which one
      // (ECONNREFUSED = reached the machine, nothing listening;
      //  EHOSTUNREACH/ETIMEDOUT = never reached the machine at all).
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
      // TLS negotiation failed — a self-signed/expired certificate, or an
      // https:// URL pointed at a plain-HTTP dev server. Distinct from
      // SocketException: the host WAS reached, the secure channel is what
      // failed, so "no internet" would be the wrong thing to tell the user.
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
      // The server answered but the body was unreadable — log the raw payload,
      // never crash on it.
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
        // 400/401/403/404/422/429/500… — the body is intact on the exception
        // (see `receiveDataWhenStatusError` in the Dio setup) and is the ONLY
        // place the API's message lives, so it is read, never discarded.
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

  /// Wraps the server's error body in a [ServerFailure], keeping the API's own
  /// message word-for-word.
  ///
  /// The extraction itself lives in [parseApiError] — one implementation for
  /// the whole app — and never throws, which matters because this runs INSIDE
  /// the repositories' `on DioException` catch: an exception raised here would
  /// escape that catch and surface as an unhandled error with the screen stuck
  /// on its loading state instead of showing a readable message.
  ///
  /// The message is left EMPTY when the body carried nothing usable; the
  /// display layer (`localizedFailureMessage`) then supplies the app's
  /// localized generic message, so no English string is invented down here.
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

/// A business-rule violation caught on the client BEFORE any request is sent
/// (invalid status transition, images outside `done`, manual `busy`, …).
/// The UI maps [errorCode] to a localized message; [message] is an
/// English fallback for logs.
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
