import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/session/user_session.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repository/profile_repo.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../data_sources/remote/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService api;
  final UserSession session;

  const ProfileRepositoryImpl(this.api, this.session);

  @override
  Future<UserEntity> updateProfile({
    required String fullname,
    required String email,
    required String address,
    required String phone,
    File? image,
  }) async {
    try {
      final response = await api.updateProfile(
        fullname,
        email,
        address,
        phone,
        image,
      );
      final user = response.data.toEntity();
      if (user == null) {
        throw ServerFailure(
          response.data.message,
          response.data.status.toString(),
        );
      }

      await session.updateProfile(
        fullname: user.fullname,
        email: user.email,
        phone: user.profile?.phone ?? phone,
        address: user.profile?.address ?? address,
        image: user.profile?.image ?? image?.path ?? session.image ?? '',
      );

      return user;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<String> logout() async {
    try {
      final response = await api.logout();
      await _clearAuthenticatedSession();
      return response.data.message;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<DashboardSummaryEntity> getDashboardSummary() async {
    try {
      final response = await api.getDashboardSummary();
      final body = response.data;
      final httpStatus = response.response.statusCode ?? 0;
      if (httpStatus < 200 ||
          httpStatus >= 300 ||
          body.status < 200 ||
          body.status >= 300 ||
          body.data == null) {
        throw ServerFailure(body.message, body.status.toString());
      }
      return body.data!.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<String> deleteAccount() async {
    try {
      final response = await api.deleteAccount();
      final httpStatus = response.response.statusCode ?? 0;
      if (httpStatus < 200 ||
          httpStatus >= 300 ||
          response.data.status < 200 ||
          response.data.status >= 300) {
        throw ServerFailure(
          response.data.message,
          response.data.status.toString(),
        );
      }
      await _clearAuthenticatedSession();
      return response.data.message;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<void> _clearAuthenticatedSession() => session.clear();
}
