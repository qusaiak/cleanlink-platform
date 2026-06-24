import '../entities/auth_entity.dart';
import '../entities/user_profile_entity.dart';

abstract class AuthRepo {
  Future<AuthEntity> login({
    required String email,
    required String password,
  });

  Future<AuthEntity> register({
    required String fullname,
    required String email,
    required String password,
  });

  Future<UserProfileEntity> updateProfile({
    required String token,
    required String image,
    required String address,
    required String phone,
  });
}
