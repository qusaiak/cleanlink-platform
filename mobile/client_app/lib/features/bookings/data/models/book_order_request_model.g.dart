// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookOrderRequestModel _$BookOrderRequestModelFromJson(
  Map<String, dynamic> json,
) => BookOrderRequestModel(
  packageId: (json['package_id'] as num).toInt(),
  location: json['location'] as String,
  startTime: json['start_time'] as String,
  note: json['note'] as String?,
);

Map<String, dynamic> _$BookOrderRequestModelToJson(
  BookOrderRequestModel instance,
) => <String, dynamic>{
  'package_id': instance.packageId,
  'location': instance.location,
  'start_time': instance.startTime,
  'note': instance.note,
};
