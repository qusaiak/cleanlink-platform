// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteDataModel _$FavoriteDataModelFromJson(Map<String, dynamic> json) =>
    FavoriteDataModel(
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      companies: (json['companies'] as List<dynamic>?)
          ?.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavoriteDataModelToJson(FavoriteDataModel instance) =>
    <String, dynamic>{
      'services': instance.services,
      'companies': instance.companies,
    };
