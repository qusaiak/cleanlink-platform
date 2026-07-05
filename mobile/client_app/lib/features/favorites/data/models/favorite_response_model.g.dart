// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteResponseModel _$FavoriteResponseModelFromJson(
  Map<String, dynamic> json,
) => FavoriteResponseModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : FavoriteDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FavoriteResponseModelToJson(
  FavoriteResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
