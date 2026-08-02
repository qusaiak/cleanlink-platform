import 'package:json_annotation/json_annotation.dart';

import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_model.dart';
import '../../domain/entities/app_notification_entity.dart';

part 'notification_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateFcmTokenResponseModel {
  final int? status;
  final String? message;
  final FcmTokenDataModel? data;

  const UpdateFcmTokenResponseModel({this.status, this.message, this.data});

  factory UpdateFcmTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateFcmTokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFcmTokenResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FcmTokenDataModel {
  final int? id;
  final int? userId;
  final String? token;
  final String? deviceType;
  final String? lang;
  final String? createdAt;
  final String? updatedAt;

  const FcmTokenDataModel({
    this.id,
    this.userId,
    this.token,
    this.deviceType,
    this.lang,
    this.createdAt,
    this.updatedAt,
  });

  factory FcmTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmTokenDataModelToJson(this);
}

class GetNotificationsResponseModel {
  final int? status;
  final String? message;
  final List<NotificationItemModel> notifications;
  final PaginationModel pagination;

  const GetNotificationsResponseModel({
    this.status,
    this.message,
    required this.notifications,
    required this.pagination,
  });

  factory GetNotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _requiredMap(json['data'], 'data');
    final items = data['data'];
    if (items is! List) {
      throw const FormatException('Expected data.data to be a list');
    }
    return GetNotificationsResponseModel(
      status: _nullableIntFromJson(json['status']),
      message: json['message']?.toString(),
      notifications: items
          .whereType<Map>()
          .map(
            (item) =>
                NotificationItemModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false),
      pagination: PaginationModel.fromJson(
        _requiredMap(data['pagination'], 'data.pagination'),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'data': notifications.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    },
  };

  PaginatedResult<AppNotificationEntity> toEntity() => PaginatedResult(
    items: notifications.map((item) => item.toEntity()).toList(),
    pagination: pagination,
  );

  static Map<String, dynamic> _requiredMap(Object? value, String field) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Expected $field to be an object');
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MarkNotificationAsReadResponseModel {
  final int? status;
  final String? message;
  final NotificationItemModel? data;

  const MarkNotificationAsReadResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory MarkNotificationAsReadResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$MarkNotificationAsReadResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MarkNotificationAsReadResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UnreadNotificationsCountResponseModel {
  final int? status;
  final String? message;
  final UnreadNotificationsCountDataModel? data;

  const UnreadNotificationsCountResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UnreadNotificationsCountResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$UnreadNotificationsCountResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UnreadNotificationsCountResponseModelToJson(this);

  int toEntity() => data?.unreadCount ?? 0;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UnreadNotificationsCountDataModel {
  @JsonKey(fromJson: _intFromJson)
  final int unreadCount;

  const UnreadNotificationsCountDataModel({this.unreadCount = 0});

  factory UnreadNotificationsCountDataModel.fromJson(
    Map<String, dynamic> json,
  ) => _$UnreadNotificationsCountDataModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UnreadNotificationsCountDataModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationItemModel {
  @JsonKey(fromJson: _intFromJson)
  final int id;
  final String? title;
  final String? body;
  @JsonKey(fromJson: _boolFromJson)
  final bool isRead;
  final String? createdAt;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? orderId;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? complaintId;
  final String? type;
  final String? status;
  final NotificationDataModel? data;

  const NotificationItemModel({
    this.id = 0,
    this.title,
    this.body,
    this.isRead = false,
    this.createdAt,
    this.orderId,
    this.complaintId,
    this.type,
    this.status,
    this.data,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationItemModelToJson(this);

  AppNotificationEntity toEntity() {
    return AppNotificationEntity(
      id: id,
      title: title ?? '',
      body: body ?? '',
      isRead: isRead,
      createdAt: createdAt == null ? null : DateTime.tryParse(createdAt!),
      orderId: data?.orderId ?? orderId,
      complaintId: data?.complaintId ?? complaintId,
      type: data?.type ?? type,
      status: data?.status ?? status,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationDataModel {
  final String? type;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? orderId;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? complaintId;
  final String? status;

  const NotificationDataModel({
    this.type,
    this.orderId,
    this.complaintId,
    this.status,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataModelToJson(this);
}

int _intFromJson(dynamic value) => _nullableIntFromJson(value) ?? 0;

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool _boolFromJson(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
  return false;
}
