// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
  id: (json['id'] as num?)?.toInt(),
  managerId: (json['manager_id'] as num?)?.toInt(),
  regionId: (json['region_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  image: json['image'] as String?,
  location: json['location'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
  isOpen: json['is_open'] as bool?,
  isFavorite: json['is_favorite'] as bool?,
  startHour: json['start_hour'] as String?,
  closeHour: json['close_hour'] as String?,
  manager: json['manager'] == null
      ? null
      : ManagerModel.fromJson(json['manager'] as Map<String, dynamic>),
  region: json['region'] == null
      ? null
      : RegionModel.fromJson(json['region'] as Map<String, dynamic>),
  services: (json['services'] as List<dynamic>?)
      ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  workers: (json['workers'] as List<dynamic>?)
      ?.map((e) => WorkerModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  reviews: (json['reviews'] as List<dynamic>?)
      ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
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
      'is_favorite': instance.isFavorite,
      'start_hour': instance.startHour,
      'close_hour': instance.closeHour,
      'manager': instance.manager,
      'region': instance.region,
      'services': instance.services,
      'workers': instance.workers,
      'reviews': instance.reviews,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
