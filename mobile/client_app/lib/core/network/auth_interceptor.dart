import 'package:client_app/core/storage/shared_storage.dart';
import 'package:dio/dio.dart';
import '../storage/storage_data.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedStorage.get(StorageData.token);

    print("TOKEN => $token");

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
