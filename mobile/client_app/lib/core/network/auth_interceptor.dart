import 'package:client_app/core/storage/shared_storage.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/config/routes/app_router.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../session/user_session.dart';
import '../storage/storage_data.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  static bool _isHandlingUnauthenticated = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedStorage.get(StorageData.token);
    final languageCode = await SharedStorage.get(StorageData.languageCode);
    print("token");
    print(token);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept-Language'] =
        languageCode != null && languageCode.isNotEmpty ? languageCode : 'en';

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isUnauthenticated(err.response)) {
      await _handleUnauthenticated(err);
    }
    handler.next(err);
  }

  bool _isUnauthenticated(Response<dynamic>? response) {
    final data = response?.data;
    final statusCode = response?.statusCode;
    String? message;

    if (data is Map) {
      message = data['message']?.toString();
    } else if (data is String) {
      message = data;
    }

    return statusCode == 401 ||
        (message?.toLowerCase().contains('unauthenticated') ?? false);
  }

  Future<void> _handleUnauthenticated(DioException err) async {
    if (_isHandlingUnauthenticated) return;
    _isHandlingUnauthenticated = true;

    err.requestOptions.headers.remove('Authorization');

    final getIt = GetIt.I;
    if (getIt.isRegistered<Dio>()) {
      getIt<Dio>().options.headers.remove('Authorization');
    }

    if (getIt.isRegistered<UserSession>()) {
      await getIt<UserSession>().clear();
    } else {
      await SharedStorage.clear();
    }

    AppSnackBar.showSessionExpired();
    AppRouter.router.go(AppRouter.kLogin);

    Future<void>.delayed(const Duration(seconds: 2), () {
      _isHandlingUnauthenticated = false;
    });
  }
}
