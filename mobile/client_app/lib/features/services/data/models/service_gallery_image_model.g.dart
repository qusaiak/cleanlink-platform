// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_gallery_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceGalleryImageModel _$ServiceGalleryImageModelFromJson(
  Map<String, dynamic> json,
) => ServiceGalleryImageModel(
  id: (json['id'] as num).toInt(),
  serviceId: (json['service_id'] as num).toInt(),
  imageBefore: json['image_before'] as String,
  imageAfter: json['image_after'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ServiceGalleryImageModelToJson(
  ServiceGalleryImageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'service_id': instance.serviceId,
  'image_before': instance.imageBefore,
  'image_after': instance.imageAfter,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
