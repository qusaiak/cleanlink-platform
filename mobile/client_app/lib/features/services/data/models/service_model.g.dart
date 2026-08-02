// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
  id: (json['id'] as num?)?.toInt(),
  companyId: (json['company_id'] as num?)?.toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  minDuration: (json['min_duration'] as num?)?.toInt(),
  maxDuration: (json['max_duration'] as num?)?.toInt(),
  minPrice: _nullableDoubleFromJson(json['minimum_price']),
  maxPrice: _nullableDoubleFromJson(json['maximum_price']),
  image: json['image'] as String?,
  discount: (json['discount'] as num?)?.toDouble(),
  isFavorite: json['is_favorite'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  company: json['company'] == null
      ? null
      : CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
  packages: (json['packages'] as List<dynamic>?)
      ?.map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  attributes: (json['attributes'] as List<dynamic>?)
      ?.map((e) => AttributeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  reviews: (json['reviews'] as List<dynamic>?)
      ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => ServiceGalleryImageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'rating': instance.rating,
      'min_duration': instance.minDuration,
      'max_duration': instance.maxDuration,
      'minimum_price': instance.minPrice,
      'maximum_price': instance.maxPrice,
      'image': instance.image,
      'discount': instance.discount,
      'is_favorite': instance.isFavorite,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'company': instance.company,
      'packages': instance.packages,
      'attributes': instance.attributes,
      'reviews': instance.reviews,
      'images': instance.images,
    };
