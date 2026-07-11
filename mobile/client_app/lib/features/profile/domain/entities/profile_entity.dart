import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final int userId;
  final String? image;
  final String? address;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.userId,
    this.image,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    image,
    address,
    phone,
    createdAt,
    updatedAt,
  ];
}
