// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionCompanyModel _$RegionCompanyModelFromJson(Map<String, dynamic> json) =>
    RegionCompanyModel(
      id: (json['id'] as num?)?.toInt(),
      managerId: (json['manager_id'] as num?)?.toInt(),
      regionId: (json['region_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      location: json['location'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      isOpen: json['is_open'] == null
          ? false
          : _isOpenFromJson(json['is_open']),
      startHour: json['start_hour'] as String?,
      closeHour: json['close_hour'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RegionCompanyModelToJson(RegionCompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'manager_id': instance.managerId,
      'region_id': instance.regionId,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'location': instance.location,
      'rating': instance.rating,
      'is_open': instance.isOpen,
      'start_hour': instance.startHour,
      'close_hour': instance.closeHour,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
