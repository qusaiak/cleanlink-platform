// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFcmTokenResponseModel _$UpdateFcmTokenResponseModelFromJson(
  Map<String, dynamic> json,
) => UpdateFcmTokenResponseModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : FcmTokenDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateFcmTokenResponseModelToJson(
  UpdateFcmTokenResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

FcmTokenDataModel _$FcmTokenDataModelFromJson(Map<String, dynamic> json) =>
    FcmTokenDataModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      token: json['token'] as String?,
      deviceType: json['device_type'] as String?,
      lang: json['lang'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FcmTokenDataModelToJson(FcmTokenDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'token': instance.token,
      'device_type': instance.deviceType,
      'lang': instance.lang,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

MarkNotificationAsReadResponseModel
_$MarkNotificationAsReadResponseModelFromJson(Map<String, dynamic> json) =>
    MarkNotificationAsReadResponseModel(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : NotificationItemModel.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MarkNotificationAsReadResponseModelToJson(
  MarkNotificationAsReadResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

UnreadNotificationsCountResponseModel
_$UnreadNotificationsCountResponseModelFromJson(Map<String, dynamic> json) =>
    UnreadNotificationsCountResponseModel(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : UnreadNotificationsCountDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$UnreadNotificationsCountResponseModelToJson(
  UnreadNotificationsCountResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

UnreadNotificationsCountDataModel _$UnreadNotificationsCountDataModelFromJson(
  Map<String, dynamic> json,
) => UnreadNotificationsCountDataModel(
  unreadCount: json['unread_count'] == null
      ? 0
      : _intFromJson(json['unread_count']),
);

Map<String, dynamic> _$UnreadNotificationsCountDataModelToJson(
  UnreadNotificationsCountDataModel instance,
) => <String, dynamic>{'unread_count': instance.unreadCount};

NotificationItemModel _$NotificationItemModelFromJson(
  Map<String, dynamic> json,
) => NotificationItemModel(
  id: json['id'] == null ? 0 : _intFromJson(json['id']),
  title: json['title'] as String?,
  body: json['body'] as String?,
  isRead: json['is_read'] == null ? false : _boolFromJson(json['is_read']),
  createdAt: json['created_at'] as String?,
  orderId: _nullableIntFromJson(json['order_id']),
  complaintId: _nullableIntFromJson(json['complaint_id']),
  type: json['type'] as String?,
  status: json['status'] as String?,
  data: json['data'] == null
      ? null
      : NotificationDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationItemModelToJson(
  NotificationItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'is_read': instance.isRead,
  'created_at': instance.createdAt,
  'order_id': instance.orderId,
  'complaint_id': instance.complaintId,
  'type': instance.type,
  'status': instance.status,
  'data': instance.data,
};

NotificationDataModel _$NotificationDataModelFromJson(
  Map<String, dynamic> json,
) => NotificationDataModel(
  type: json['type'] as String?,
  orderId: _nullableIntFromJson(json['order_id']),
  complaintId: _nullableIntFromJson(json['complaint_id']),
  status: json['status'] as String?,
);

Map<String, dynamic> _$NotificationDataModelToJson(
  NotificationDataModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'order_id': instance.orderId,
  'complaint_id': instance.complaintId,
  'status': instance.status,
};
