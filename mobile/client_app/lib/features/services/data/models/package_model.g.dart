// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) => PackageModel(
  id: (json['id'] as num?)?.toInt(),
  serviceId: (json['service_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  price: (json['price'] as num?)?.toInt(),
  priceAfterDiscount: (json['price_after_discount'] as num?)?.toInt(),
  details: (json['details'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PackageModelToJson(PackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'name': instance.name,
      'duration': instance.duration,
      'price': instance.price,
      'price_after_discount': instance.priceAfterDiscount,
      'details': instance.details,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
