import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../repository/profile_repo.dart';

class UpdateClientProfileUseCase {
  final ProfileRepository repo;

  const UpdateClientProfileUseCase(this.repo);

  Future<UserEntity> call(UpdateClientProfileParams params) {
    return repo.updateProfile(
      fullname: params.fullname,
      email: params.email,
      address: params.address,
      phone: params.phone,
      image: params.image,
    );
  }
}

class UpdateClientProfileParams extends Equatable {
  final String fullname;
  final String email;
  final String address;
  final String phone;
  final File? image;

  const UpdateClientProfileParams({
    required this.fullname,
    required this.email,
    required this.address,
    required this.phone,
    this.image,
  });

  @override
  List<Object?> get props => [fullname, email, address, phone, image?.path];
}

class LogoutUseCase {
  final ProfileRepository repo;

  const LogoutUseCase(this.repo);

  Future<String> call() {
    return repo.logout();
  }
}
