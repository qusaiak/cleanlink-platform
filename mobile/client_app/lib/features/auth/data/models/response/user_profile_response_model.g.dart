// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileResponseModel _$UserProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => UserProfileResponseModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  image: json['image'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserProfileResponseModelToJson(
  UserProfileResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'image': instance.image,
  'address': instance.address,
  'phone': instance.phone,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
