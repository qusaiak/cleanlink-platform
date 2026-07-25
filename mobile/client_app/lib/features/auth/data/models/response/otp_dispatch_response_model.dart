import 'package:json_annotation/json_annotation.dart';

part 'otp_dispatch_response_model.g.dart';

@JsonSerializable()
class OtpDispatchResponseModel {
  final String email;

  const OtpDispatchResponseModel({required this.email});

  factory OtpDispatchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpDispatchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpDispatchResponseModelToJson(this);
}
