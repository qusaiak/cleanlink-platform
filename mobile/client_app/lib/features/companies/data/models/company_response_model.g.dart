// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyResponseModel _$CompanyResponseModelFromJson(
  Map<String, dynamic> json,
) => CompanyResponseModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CompanyResponseModelToJson(
  CompanyResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
