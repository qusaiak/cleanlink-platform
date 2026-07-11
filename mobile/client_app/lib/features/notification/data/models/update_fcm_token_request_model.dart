import 'package:json_annotation/json_annotation.dart';

part 'update_fcm_token_request_model.g.dart';

@JsonSerializable(createFactory: false)
class UpdateFcmTokenRequestModel {
  @JsonKey(name: 'fcm_token')
  final String fcmToken;

  @JsonKey(name: 'device_type')
  final String deviceType;

  final String lang;

  const UpdateFcmTokenRequestModel({
    required this.fcmToken,
    required this.deviceType,
    required this.lang,
  });

  Map<String, dynamic> toJson() => _$UpdateFcmTokenRequestModelToJson(this);
}
