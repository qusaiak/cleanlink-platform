// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileResponseModel _$UpdateProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => UpdateProfileResponseModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : UserModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateProfileResponseModelToJson(
  UpdateProfileResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
