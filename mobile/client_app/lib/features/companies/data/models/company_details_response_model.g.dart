// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyDetailsResponseModel _$CompanyDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => CompanyDetailsResponseModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CompanyModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompanyDetailsResponseModelToJson(
  CompanyDetailsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
