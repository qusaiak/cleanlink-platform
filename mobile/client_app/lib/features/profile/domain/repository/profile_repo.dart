import 'dart:io';

import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> updateProfile({
    required String fullname,
    required String email,
    required String address,
    required String phone,
    File? image,
  });

  Future<String> logout();
}
