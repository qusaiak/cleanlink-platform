import 'package:equatable/equatable.dart';

import '../entities/auth_entity.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepo repo;

  const LoginUseCase(this.repo);

  Future<AuthEntity> call(LoginParams params) {
    return repo.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
