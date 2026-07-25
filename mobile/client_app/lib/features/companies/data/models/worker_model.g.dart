// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerModel _$WorkerModelFromJson(Map<String, dynamic> json) => WorkerModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  companyId: (json['company_id'] as num).toInt(),
  experienceYears: (json['experience_years'] as num).toInt(),
  rating: (json['rating'] as num).toDouble(),
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$WorkerModelToJson(WorkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'company_id': instance.companyId,
      'experience_years': instance.experienceYears,
      'rating': instance.rating,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'user': instance.user,
    };
