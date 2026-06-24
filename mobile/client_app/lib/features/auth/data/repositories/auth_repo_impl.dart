import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/base_response_model.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/session/user_session.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/auth_api_service.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/request/user_profile_request_model.dart';
import '../models/response/auth_response_model.dart';
import '../models/response/user_profile_response_model.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthApiService api;
  final UserSession session;

  const AuthRepoImpl(this.api, this.session);

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.login(
        LoginRequestModel(email: email, password: password),
      );
      final auth = _resolveAuth(response.data);
      await session.updateAuthLogin(
        fullname: auth.user.fullname,
        email: auth.user.email,
        token: auth.accessToken,
        image: auth.user.profile!.image ?? '',
        phone: auth.user.profile!.phone ?? '',
        address: auth.user.profile!.address ?? '',
      );
      return auth;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<AuthEntity> register({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.register(
        RegisterRequestModel(
          fullname: fullname,
          email: email,
          password: password,
        ),
      );
      final auth = _resolveAuth(response.data);
      await session.updateAuthRegister(
        fullname: auth.user.fullname,
        email: auth.user.email,
        token: auth.accessToken,
      );
      return auth;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<UserProfileEntity> updateProfile({
    required String token,
    required String image,
    required String address,
    required String phone,
  }) async {
    try {
      final response = await api.updateProfile(
        'Bearer $token',
        UserProfileRequestModel(
          image: image,
          address: address,
          phone: phone,
        ),
      );
      final profile = _resolveProfile(response.data);
      await session.updateProfile(
        phone: profile.phone ?? phone,
        address: profile.address ?? address,
        image: profile.image ?? image,
      );
      return profile;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  AuthEntity _resolveAuth(BaseResponseModel<AuthResponseModel> baseResponse) {
    final data = baseResponse.data;
    if (data == null) {
      throw ServerFailure(
        baseResponse.message,
        baseResponse.status.toString(),
      );
    }
    return data.toEntity();
  }

  UserProfileEntity _resolveProfile(
    BaseResponseModel<UserProfileResponseModel> baseResponse,
  ) {
    final data = baseResponse.data;
    if (data == null) {
      throw ServerFailure(
        baseResponse.message,
        baseResponse.status.toString(),
      );
    }
    return data.toEntity();
  }
}
