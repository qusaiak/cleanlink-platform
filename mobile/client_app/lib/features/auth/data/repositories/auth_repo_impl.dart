import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/base_response_model.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/session/user_session.dart';
import '../../../../core/utils/map_address_normalizer.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/otp_dispatch_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/auth_api_service.dart';
import '../models/request/change_password_request_model.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/request/resend_otp_request_model.dart';
import '../models/request/verify_otp_request_model.dart';
import '../models/response/auth_response_model.dart';
import '../models/response/otp_dispatch_response_model.dart';
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
      await _persistAuthenticatedSession(auth);
      return auth;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure('Invalid login response', '');
    }
  }

  @override
  Future<OtpDispatchEntity> register({
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
      return _resolveOtpDispatch(response.data, expectedStatus: 210);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure('Unexpected registration response', '');
    }
  }

  @override
  Future<AuthEntity> verifyOtp({
    required String fullname,
    required String email,
    required String password,
    required String otpCode,
  }) async {
    try {
      final response = await api.verifyOtp(
        VerifyOtpRequestModel(
          fullname: fullname,
          email: email,
          password: password,
          otpCode: otpCode,
        ),
      );
      final auth = _resolveAuth(response.data, expectedStatus: 211);
      await _persistAuthenticatedSession(auth);
      return auth;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure('Invalid OTP verification response', '');
    }
  }

  @override
  Future<OtpDispatchEntity> resendOtp({
    required String fullname,
    required String email,
  }) async {
    try {
      final response = await api.resendOtp(
        ResendOtpRequestModel(fullname: fullname, email: email),
      );
      return _resolveOtpDispatch(response.data, expectedStatus: 210);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure('Unexpected resend OTP response', '');
    }
  }

  @override
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await api.changePassword(
        ChangePasswordRequestModel(
          oldPassword: oldPassword,
          newPassword: newPassword,
          newPasswordConfirmation: newPasswordConfirmation,
        ),
      );
      return response.data.message;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<UserProfileEntity> updateProfile({
    File? image,
    required double latitude,
    required double longitude,
    required String phone,
  }) => updateProfileWithAddress(
    image: image,
    latitude: latitude,
    longitude: longitude,
    address: '',
    phone: phone,
  );

  @override
  Future<UserProfileEntity> updateProfileWithAddress({
    File? image,
    required double latitude,
    required double longitude,
    required String address,
    required String phone,
  }) async {
    try {
      final response = await api.updateProfile(
        image,
        null,
        null,
        normalizeGoogleMapAddress(address),
        phone,
      );
      final profile = _resolveProfile(response.data);
      await session.updateProfile(
        phone: profile.phone ?? phone,
        address: profile.address ?? normalizeGoogleMapAddress(address),
        image: profile.image ?? image?.path ?? session.image ?? '',
      );
      return profile;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  AuthEntity _resolveAuth(
    BaseResponseModel<AuthResponseModel> baseResponse, {
    int? expectedStatus,
  }) {
    if (expectedStatus != null && baseResponse.status != expectedStatus) {
      throw ServerFailure(baseResponse.message, baseResponse.status.toString());
    }
    final data = baseResponse.data;
    if (data == null || data.accessToken.trim().isEmpty) {
      throw ServerFailure(baseResponse.message, baseResponse.status.toString());
    }
    return AuthEntity(
      user: data.user.toEntity(),
      accessToken: data.accessToken,
      status: baseResponse.status,
      message: baseResponse.message,
    );
  }

  OtpDispatchEntity _resolveOtpDispatch(
    BaseResponseModel<OtpDispatchResponseModel> baseResponse, {
    required int expectedStatus,
  }) {
    final data = baseResponse.data;
    if (baseResponse.status != expectedStatus ||
        data == null ||
        data.email.trim().isEmpty) {
      throw ServerFailure(baseResponse.message, baseResponse.status.toString());
    }
    return OtpDispatchEntity(
      status: baseResponse.status,
      message: baseResponse.message,
      email: data.email,
    );
  }

  Future<void> _persistAuthenticatedSession(AuthEntity auth) {
    final profile = auth.user.profile;
    return session.updateAuthenticatedUser(
      id: auth.user.id,
      role: auth.user.role,
      fullname: auth.user.fullname,
      email: auth.user.email,
      token: auth.accessToken,
      image: profile?.image ?? '',
      phone: profile?.phone ?? '',
      address: profile?.address ?? '',
    );
  }

  UserProfileEntity _resolveProfile(
    BaseResponseModel<UserProfileResponseModel> baseResponse,
  ) {
    final data = baseResponse.data;
    if (data == null) {
      throw ServerFailure(baseResponse.message, baseResponse.status.toString());
    }
    return data.toEntity();
  }
}
