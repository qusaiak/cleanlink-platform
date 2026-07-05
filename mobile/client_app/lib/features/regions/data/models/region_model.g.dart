// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionModel _$RegionModelFromJson(Map<String, dynamic> json) => RegionModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  image: json['image'] as String?,
  managerId: (json['manager_id'] as num?)?.toInt(),
  manager: json['manager'] == null
      ? null
      : ManagerModel.fromJson(json['manager'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegionModelToJson(RegionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'manager_id': instance.managerId,
      'manager': instance.manager,
    };
