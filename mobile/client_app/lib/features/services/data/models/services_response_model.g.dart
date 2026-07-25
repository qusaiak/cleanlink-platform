// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicesResponseModel _$ServicesResponseModelFromJson(
  Map<String, dynamic> json,
) => ServicesResponseModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ServicesResponseModelToJson(
  ServicesResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
