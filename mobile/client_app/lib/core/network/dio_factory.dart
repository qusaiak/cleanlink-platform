import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
        headers: {HttpHeader.accept.value: 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    return dio;
  }
}
