import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class RegisterRequestModel {
  final String fullname;
  final String email;
  final String password;

  const RegisterRequestModel({
    required this.fullname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
