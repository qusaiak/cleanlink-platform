import 'package:equatable/equatable.dart';

import 'profile_entity.dart';

class UserEntity extends Equatable {
  final int id;
  final String fullname;
  final String email;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProfileEntity? profile;

  const UserEntity({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.profile,
  });

  @override
  List<Object?> get props => [
        id,
        fullname,
        email,
        role,
        createdAt,
        updatedAt,
        profile,
      ];
}
