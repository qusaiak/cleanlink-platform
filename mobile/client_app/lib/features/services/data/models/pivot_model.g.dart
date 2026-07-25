// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pivot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PivotModel _$PivotModelFromJson(Map<String, dynamic> json) => PivotModel(
  serviceId: (json['service_id'] as num?)?.toInt(),
  attributeId: (json['attribute_id'] as num?)?.toInt(),
  price: json['price'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PivotModelToJson(PivotModel instance) =>
    <String, dynamic>{
      'service_id': instance.serviceId,
      'attribute_id': instance.attributeId,
      'price': instance.price,
      'duration': instance.duration,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
