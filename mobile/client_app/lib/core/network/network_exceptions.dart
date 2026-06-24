import 'package:dio/dio.dart';

import '../error/failure.dart';

abstract class NetworkExceptions {
  NetworkExceptions._();

  static ServerFailure fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          'Connection timeout with the server',
          ErrorCode.connectionTimeout,
        );
      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          'Send timeout with the server',
          ErrorCode.sendTimeout,
        );
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          'Receive timeout with the server',
          ErrorCode.receiveTimeout,
        );
      case DioExceptionType.connectionError:
        return const ServerFailure(
          'No internet connection',
          ErrorCode.noInternet,
        );
      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate from the server', '');
      case DioExceptionType.cancel:
        return const ServerFailure('Request to the server was cancelled', '');
      case DioExceptionType.badResponse:
        return _fromResponse(e.response);
      case DioExceptionType.unknown:
        return const ServerFailure(
          'Oops, something went wrong. Please try again',
          '',
        );
    }
  }

  static ServerFailure _fromResponse(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['ErrorMessage'];
      final code = (data['status'] ?? data['ErrorCode'] ?? '').toString();
      if (message != null) {
        return ServerFailure(message.toString(), code);
      }
    }
    return const ServerFailure('There was an error, please try again', '');
  }
}
