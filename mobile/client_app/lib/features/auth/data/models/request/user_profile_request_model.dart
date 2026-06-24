import 'package:json_annotation/json_annotation.dart';

part 'user_profile_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class UserProfileRequestModel {
  final String image;
  final String address;
  final String phone;

  const UserProfileRequestModel({
    this.image = '',
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toJson() => _$UserProfileRequestModelToJson(this);
}
