import 'package:equatable/equatable.dart';

import '../repositories/auth_repo.dart';

class ChangePasswordUseCase {
  final AuthRepo repo;

  const ChangePasswordUseCase(this.repo);

  Future<String> call(ChangePasswordParams params) {
    return repo.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
      newPasswordConfirmation: params.newPasswordConfirmation,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  @override
  List<Object?> get props => [
    oldPassword,
    newPassword,
    newPasswordConfirmation,
  ];
}
