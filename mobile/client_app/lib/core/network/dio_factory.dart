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
    // if (kDebugMode && AppConfig.enableLogs) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('================ REQUEST ================');
          print('METHOD: ${options.method}');
          print('URL: ${options.uri}');
          print('HEADERS: ${options.headers}');
          print('QUERY: ${options.queryParameters}');
          print('DATA: ${options.data}');
          print('=========================================');

          handler.next(options);
        },
        onResponse: (response, handler) {
          print('================ RESPONSE ===============');
          print('STATUS: ${response.statusCode}');
          print('URL: ${response.requestOptions.uri}');
          print('DATA: ${response.data}');
          print('=========================================');

          handler.next(response);
        },
        onError: (error, handler) {
          print('================ ERROR ==================');
          print('METHOD: ${error.requestOptions.method}');
          print('URL: ${error.requestOptions.uri}');
          print('STATUS: ${error.response?.statusCode}');
          print('REQUEST DATA: ${error.requestOptions.data}');
          print('RESPONSE DATA: ${error.response?.data}');
          print('ERROR: ${error.message}');
          print('=========================================');

          handler.next(error);
        },
      ),
    );
    // }
    return dio;
  }
}
