// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
  id: _intFromJson(json['id']),
  managerId: _intFromJson(json['manager_id']),
  regionId: _intFromJson(json['region_id']),
  name: json['name'] as String?,
  description: json['description'] as String?,
  image: json['image'] as String?,
  location: json['location'] as String?,
  rating: _doubleFromJson(json['rating']),
  isFavorite: _boolFromJson(json['is_favorite']),
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
  workTimes: json['workTimes'] == null
      ? const []
      : _workTimesFromJson(json['workTimes']),
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
      'is_favorite': instance.isFavorite,
      'manager': instance.manager,
      'region': instance.region,
      'services': instance.services,
      'workers': instance.workers,
      'reviews': instance.reviews,
      'workTimes': instance.workTimes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
