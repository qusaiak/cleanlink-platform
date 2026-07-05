// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDetailsResponseModel _$CategoryDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => CategoryDetailsResponseModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CategoryModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CategoryDetailsResponseModelToJson(
  CategoryDetailsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
