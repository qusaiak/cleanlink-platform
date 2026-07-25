import 'package:equatable/equatable.dart';

import '../entities/auth_entity.dart';
import '../repositories/auth_repo.dart';

class VerifyOtpUseCase {
  final AuthRepo repo;

  const VerifyOtpUseCase(this.repo);

  Future<AuthEntity> call(VerifyOtpParams params) {
    return repo.verifyOtp(
      fullname: params.fullname,
      email: params.email,
      password: params.password,
      otpCode: params.otpCode,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String fullname;
  final String email;
  final String password;
  final String otpCode;

  const VerifyOtpParams({
    required this.fullname,
    required this.email,
    required this.password,
    required this.otpCode,
  });

  @override
  List<Object?> get props => [fullname, email, password, otpCode];
}
