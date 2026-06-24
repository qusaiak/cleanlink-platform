import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_profile_entity.dart';

part 'user_profile_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfileResponseModel {
  final int id;
  final int userId;
  final String? image;
  final String? address;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileResponseModel({
    required this.id,
    required this.userId,
    this.image,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseModelToJson(this);

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        userId: userId,
        image: image,
        address: address,
        phone: phone,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
