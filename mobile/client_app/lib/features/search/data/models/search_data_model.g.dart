// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchDataModel _$SearchDataModelFromJson(Map<String, dynamic> json) =>
    SearchDataModel(
      regions: (json['regions'] as List<dynamic>?)
          ?.map((e) => RegionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      companies: (json['companies'] as List<dynamic>?)
          ?.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchDataModelToJson(SearchDataModel instance) =>
    <String, dynamic>{
      'regions': instance.regions,
      'categories': instance.categories,
      'companies': instance.companies,
      'services': instance.services,
      'offers': instance.offers,
    };
