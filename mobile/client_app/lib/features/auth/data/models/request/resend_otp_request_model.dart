import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class ResendOtpRequestModel {
  final String fullname;
  final String email;

  const ResendOtpRequestModel({required this.fullname, required this.email});

  Map<String, dynamic> toJson() => _$ResendOtpRequestModelToJson(this);
}
