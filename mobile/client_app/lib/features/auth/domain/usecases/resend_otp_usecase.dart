import 'package:equatable/equatable.dart';

import '../entities/otp_dispatch_entity.dart';
import '../repositories/auth_repo.dart';

class ResendOtpUseCase {
  final AuthRepo repo;

  const ResendOtpUseCase(this.repo);

  Future<OtpDispatchEntity> call(ResendOtpParams params) {
    return repo.resendOtp(fullname: params.fullname, email: params.email);
  }
}

class ResendOtpParams extends Equatable {
  final String fullname;
  final String email;

  const ResendOtpParams({required this.fullname, required this.email});

  @override
  List<Object?> get props => [fullname, email];
}
