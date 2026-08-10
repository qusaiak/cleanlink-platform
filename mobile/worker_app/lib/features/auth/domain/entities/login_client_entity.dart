import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final int id;
  final String fullname;
  final String email;
  final String role;
  final String? profileImage;
  final String? address;
  final String? phone;
  final String accessToken;

  const LoginEntity({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    this.profileImage,
    this.address,
    this.phone,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
    id,
    fullname,
    email,
    role,
    profileImage,
    address,
    phone,
    accessToken,
  ];
}
