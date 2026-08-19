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

    if (AppConfig.enableLogs) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('');
            debugPrint('==================== REQUEST ====================');
            debugPrint('METHOD: ${options.method}');
            debugPrint('URL: ${options.uri}');
            debugPrint('HEADERS:');
            options.headers.forEach((key, value) {
              debugPrint('$key: $value');
            });
            debugPrint('QUERY PARAMETERS: ${options.queryParameters}');
            debugPrint('BODY: ${options.data}');
            debugPrint('=================================================');
            debugPrint('');

            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('');
            debugPrint('==================== RESPONSE ===================');
            debugPrint('METHOD: ${response.requestOptions.method}');
            debugPrint('URL: ${response.requestOptions.uri}');
            debugPrint('STATUS CODE: ${response.statusCode}');
            debugPrint('RESPONSE: ${response.data}');
            debugPrint('=================================================');
            debugPrint('');

            handler.next(response);
          },
          onError: (error, handler) {
            debugPrint('');
            debugPrint('===================== ERROR =====================');
            debugPrint('METHOD: ${error.requestOptions.method}');
            debugPrint('URL: ${error.requestOptions.uri}');
            debugPrint('STATUS CODE: ${error.response?.statusCode}');
            debugPrint('REQUEST BODY: ${error.requestOptions.data}');
            debugPrint('ERROR TYPE: ${error.type}');
            debugPrint('ERROR MESSAGE: ${error.message}');
            debugPrint('RESPONSE: ${error.response?.data}');
            debugPrint('=================================================');
            debugPrint('');

            handler.next(error);
          },
        ),
      );
    }

    return dio;
  }
}
