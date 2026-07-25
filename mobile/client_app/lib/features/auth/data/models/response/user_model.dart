import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../../profile/data/models/profile_model.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final int id;
  final String fullname;
  final String email;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProfileModel? profile;

  const UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
    id: id,
    fullname: fullname,
    email: email,
    role: role,
    createdAt: createdAt,
    updatedAt: updatedAt,
    profile: profile?.toEntity(),
  );
}
