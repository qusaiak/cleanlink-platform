import 'dart:io';

import 'package:equatable/equatable.dart';

import '../entities/user_profile_entity.dart';
import '../repositories/auth_repo.dart';

class UpdateProfileUseCase {
  final AuthRepo repo;

  const UpdateProfileUseCase(this.repo);

  Future<UserProfileEntity> call(UpdateProfileParams params) {
    return repo.updateProfileWithAddress(
      image: params.image,
      latitude: params.latitude,
      longitude: params.longitude,
      address: params.address,
      phone: params.phone,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final File? image;
  final double latitude;
  final double longitude;
  final String phone;
  final String address;

  const UpdateProfileParams({
    this.image,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [image?.path, latitude, longitude, address, phone];
}
