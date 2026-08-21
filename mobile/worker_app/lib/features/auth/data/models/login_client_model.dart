import 'package:dio/dio.dart';

import '../../domain/entities/login_client_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.id,
    required super.fullname,
    required super.email,
    required super.role,
    super.profileImage,
    super.address,
    super.phone,
    required super.accessToken,
  });

  factory LoginModel.fromResponse(Response<dynamic> response) {
    final body = response.data;
    if (body is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Unexpected login response body',
      );
    }

    final model = LoginModel.fromJson(Map<String, dynamic>.from(body));
    if (model.accessToken.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Login response carried no access_token',
      );
    }
    return model;
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    final user = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'] as Map)
        : data;
    final profile = user['profile'] is Map
        ? Map<String, dynamic>.from(user['profile'] as Map)
        : const <String, dynamic>{};

    return LoginModel(
      id: _asInt(user['id']),
      fullname: (user['fullname'] ?? '').toString(),
      email: (user['email'] ?? '').toString(),
      role: (user['role'] ?? '').toString(),
      profileImage: profile['image']?.toString(),
      address: profile['address']?.toString(),
      phone: profile['phone']?.toString(),

      accessToken: (data['access_token'] ?? json['access_token'] ?? '')
          .toString(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
