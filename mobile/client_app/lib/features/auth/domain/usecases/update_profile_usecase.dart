import 'package:equatable/equatable.dart';

import '../entities/user_profile_entity.dart';
import '../repositories/auth_repo.dart';

class UpdateProfileUseCase {
  final AuthRepo repo;

  const UpdateProfileUseCase(this.repo);

  Future<UserProfileEntity> call(UpdateProfileParams params) {
    return repo.updateProfile(
      token: params.token,
      image: params.image,
      address: params.address,
      phone: params.phone,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String token;
  final String image;
  final String address;
  final String phone;

  const UpdateProfileParams({
    required this.token,
    required this.image,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [token, image, address, phone];
}
