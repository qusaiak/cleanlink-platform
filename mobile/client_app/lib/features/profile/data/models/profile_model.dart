import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileModel {
  final int id;
  final int userId;
  final String? image;
  final String? address;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.userId,
    this.image,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    userId: userId,
    image: image,
    address: address,
    phone: phone,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
