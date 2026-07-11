import 'dart:io';

import 'package:equatable/equatable.dart';

import '../entities/user_profile_entity.dart';
import '../repositories/auth_repo.dart';

class UpdateProfileUseCase {
  final AuthRepo repo;

  const UpdateProfileUseCase(this.repo);

  Future<UserProfileEntity> call(UpdateProfileParams params) {
    return repo.updateProfile(
      image: params.image,
      address: params.address,
      phone: params.phone,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final File? image;
  final String address;
  final String phone;

  const UpdateProfileParams({
    this.image,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [image?.path, address, phone];
}
