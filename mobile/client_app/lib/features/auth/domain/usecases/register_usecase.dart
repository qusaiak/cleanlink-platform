import 'package:equatable/equatable.dart';

import '../entities/auth_entity.dart';
import '../repositories/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo repo;

  const RegisterUseCase(this.repo);

  Future<AuthEntity> call(RegisterParams params) {
    return repo.register(
      fullname: params.fullname,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String fullname;
  final String email;
  final String password;

  const RegisterParams({
    required this.fullname,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullname, email, password];
}
