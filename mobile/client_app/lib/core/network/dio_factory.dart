import 'package:dio/dio.dart';

import '../../config/constants/app_config.dart';
import 'auth_interceptor.dart';
import 'http_headers.dart';

abstract class DioFactory {
  DioFactory._();

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.timeout),
        receiveTimeout: Duration(milliseconds: AppConfig.timeout),
        sendTimeout: Duration(milliseconds: AppConfig.timeout),
        headers: {HttpHeader.accept.value: 'application/json'},
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    if (AppConfig.enableLogs) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}
