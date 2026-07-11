import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/response/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';

part 'update_profile_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateProfileResponseModel {
  final int status;
  final String message;
  final UserModel? data;

  const UpdateProfileResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileResponseModelToJson(this);

  UserEntity? toEntity() => data?.toEntity();
}
