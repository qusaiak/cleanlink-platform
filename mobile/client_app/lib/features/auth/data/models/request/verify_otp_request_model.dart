import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class VerifyOtpRequestModel {
  final String fullname;
  final String email;
  final String password;
  final String otpCode;

  const VerifyOtpRequestModel({
    required this.fullname,
    required this.email,
    required this.password,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpRequestModelToJson(this);
}
