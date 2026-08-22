import 'package:dio/dio.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/network_exceptions.dart';
import '../domain/chat_error_code.dart';

abstract final class ChatFailureMapper {
  static ServerFailure fromDio(DioException error) {
    final data = error.response?.data;
    if (error.type == DioExceptionType.badResponse && data is Map) {
      final code = data['code']?.toString();
      if (code != null && ChatErrorCode.values.contains(code)) {
        return ServerFailure(data['message']?.toString() ?? '', code);
      }
    }

    return NetworkExceptions.fromDio(error);
  }
}
