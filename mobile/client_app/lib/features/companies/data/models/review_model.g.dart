// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: (json['id'] as num).toInt(),
  clientId: (json['client_id'] as num).toInt(),
  comment: json['comment'] as String,
  rating: ReviewModel._ratingFromJson(json['rating']),
  reviewableId: (json['reviewable_id'] as num).toInt(),
  reviewableType: json['reviewable_type'] as String,
  client: UserModel.fromJson(json['client'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'comment': instance.comment,
      'rating': instance.rating,
      'reviewable_id': instance.reviewableId,
      'reviewable_type': instance.reviewableType,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'client': instance.client,
    };
