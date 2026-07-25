// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrdersResponseModel _$GetOrdersResponseModelFromJson(
  Map<String, dynamic> json,
) => GetOrdersResponseModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetOrdersResponseModelToJson(
  GetOrdersResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

BookOrderResponseModel _$BookOrderResponseModelFromJson(
  Map<String, dynamic> json,
) => BookOrderResponseModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : BookingModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookOrderResponseModelToJson(
  BookOrderResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

ShowOrderResponseModel _$ShowOrderResponseModelFromJson(
  Map<String, dynamic> json,
) => ShowOrderResponseModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : BookingModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShowOrderResponseModelToJson(
  ShowOrderResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

CancelOrderResponseModel _$CancelOrderResponseModelFromJson(
  Map<String, dynamic> json,
) => CancelOrderResponseModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : BookingModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CancelOrderResponseModelToJson(
  CancelOrderResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
