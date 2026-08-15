import 'package:dio/dio.dart';

import '../../../../../config/constants/api_url_parameters.dart';
import '../models/login_client_model.dart';

abstract class AuthApiService {
  Future<LoginModel> login({required String email, required String password});

  /// POST /api/auth/logout — no body; the bearer token is added by the shared
  /// Dio interceptor.
  Future<void> logout();
}

class AuthApiServiceImpl implements AuthApiService {
  final Dio dio;

  AuthApiServiceImpl(this.dio);

  /// How many extra attempts a login gets when the FIRST one fails purely for
  /// transport reasons (cold server / cold socket). Credentials errors, 4xx and
  /// 5xx are never retried — only transport failures are.
  static const int _maxRetries = 2;

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    // Exactly the two keys the API expects, lower-case snake-free names, sent
    // as a Dart map so Dio JSON-encodes the body itself (no hand-rolled
    // jsonEncode, no double encoding). The email is trimmed because a trailing
    // space from the keyboard's autocomplete is a silent 422; the password
    // never is — whitespace can be part of it.
    final response = await _postWithRetry(
      ApiUrlParameters.login,
      {'email': email.trim(), 'password': password},
    );
    return LoginModel.fromResponse(response);
  }

  @override
  Future<void> logout() async {
    await dio.post(ApiUrlParameters.logout);
  }

  /// POSTs [data] to [path], retrying with a short linear backoff while the
  /// failure is a pure transport failure (connect/send/receive timeout, socket
  /// error). This is what makes the very first request of a session — against a
  /// server that still has to warm up — reliable instead of a coin flip.
  ///
  /// A response that arrives (any status) is returned/thrown immediately: a
  /// wrong password must never be retried.
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
          // Pinned per-request as well as on the shared client, so this call
          // can never inherit a different content type (e.g. multipart left
          // over from an upload) and always asks Laravel for JSON.
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

  /// True for failures where the request never produced a server response, so
  /// replaying it is safe and likely to succeed.
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
