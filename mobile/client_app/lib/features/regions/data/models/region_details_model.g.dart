// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionDetailsModel _$RegionDetailsModelFromJson(Map<String, dynamic> json) =>
    RegionDetailsModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      manager: json['manager'] == null
          ? null
          : ManagerModel.fromJson(json['manager'] as Map<String, dynamic>),
      companies: (json['companies'] as List<dynamic>?)
          ?.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegionDetailsModelToJson(RegionDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'manager': instance.manager,
      'companies': instance.companies,
    };
