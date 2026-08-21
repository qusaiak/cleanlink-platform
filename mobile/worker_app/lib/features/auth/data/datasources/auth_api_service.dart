import 'package:dio/dio.dart';

import '../../../../../config/constants/api_url_parameters.dart';
import '../models/login_client_model.dart';

abstract class AuthApiService {
  Future<LoginModel> login({required String email, required String password});

  Future<void> logout();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}

class AuthApiServiceImpl implements AuthApiService {
  final Dio dio;

  AuthApiServiceImpl(this.dio);

  static const int _maxRetries = 2;

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _postWithRetry(ApiUrlParameters.login, {
      'email': email.trim(),
      'password': password,
    });
    return LoginModel.fromResponse(response);
  }

  @override
  Future<void> logout() async {
    await dio.post(ApiUrlParameters.logout);
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    await dio.put(
      ApiUrlParameters.changePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );
  }

  Future<Response<dynamic>> _postWithRetry(
    String path,
    Map<String, dynamic> data,
  ) async {
    DioException? lastError;

    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await dio.post(
          path,
          data: data,

          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: const {'Accept': 'application/json'},
          ),
        );
      } on DioException catch (e) {
        if (!_isTransient(e) || attempt == _maxRetries) rethrow;
        lastError = e;
        await Future.delayed(Duration(milliseconds: 400 * (attempt + 1)));
      }
    }

    throw lastError!;
  }

  bool _isTransient(DioException e) {
    if (e.response != null) return false;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
