// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceDetailsResponseModel _$ServiceDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => ServiceDetailsResponseModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: ServiceModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ServiceDetailsResponseModelToJson(
  ServiceDetailsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
