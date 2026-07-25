import 'dart:io';

import '../entities/auth_entity.dart';
import '../entities/otp_dispatch_entity.dart';
import '../entities/user_profile_entity.dart';

abstract class AuthRepo {
  Future<AuthEntity> login({required String email, required String password});

  Future<OtpDispatchEntity> register({
    required String fullname,
    required String email,
    required String password,
  });

  Future<AuthEntity> verifyOtp({
    required String fullname,
    required String email,
    required String password,
    required String otpCode,
  });

  Future<OtpDispatchEntity> resendOtp({
    required String fullname,
    required String email,
  });

  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  Future<UserProfileEntity> updateProfile({
    File? image,
    required String address,
    required String phone,
  });
}
