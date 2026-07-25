import 'package:json_annotation/json_annotation.dart';

part 'logout_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LogoutResponseModel {
  final int status;
  final String message;
  final List<dynamic>? data;

  const LogoutResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutResponseModelToJson(this);
}
