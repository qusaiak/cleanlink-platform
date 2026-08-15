import 'dart:io';

import '../../../auth/domain/entities/user_entity.dart';
import '../entities/dashboard_summary_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> updateProfile({
    required String fullname,
    required String email,
    required String phone,
    required String address,
    File? image,
  });

  Future<String> logout();

  Future<DashboardSummaryEntity> getDashboardSummary();

  Future<String> deleteAccount();
}
