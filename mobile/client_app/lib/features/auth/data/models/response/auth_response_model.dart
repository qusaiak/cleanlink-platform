import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_entity.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthResponseModel {
  final UserModel user;
  final String accessToken;

  const AuthResponseModel({required this.user, required this.accessToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthEntity toEntity() =>
      AuthEntity(user: user.toEntity(), accessToken: accessToken);
}
