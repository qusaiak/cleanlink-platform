import 'dart:convert';

import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead,
    super.requestId,
    super.clientName,
    super.serviceName,
    super.location,
    super.scheduledAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);

    final rawId = json['id'];
    if (rawId == null || rawId.toString().isEmpty) {
      throw const FormatException('Notification entry has no id');
    }

    return AppNotificationModel(
      id: rawId.toString(),
      type: _typeFromCode((json['type'] ?? data['type'])?.toString()),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? json['message'] ?? '').toString(),
      createdAt:
          _parseDate(json['createdAt'] ?? json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isRead: _parseBool(json['isRead'] ?? json['is_read']),

      requestId: (json['requestId'] ?? json['request_id'] ?? data['order_id'])
          ?.toString(),
      clientName: (json['clientName'] ?? json['client_name'])?.toString(),
      serviceName: (json['serviceName'] ?? json['service_name'])?.toString(),
      location: json['location']?.toString(),
      scheduledAt: _parseDate(json['scheduledAt'] ?? json['scheduled_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': typeCode(type),
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
    'requestId': requestId,
    'clientName': clientName,
    'serviceName': serviceName,
    'location': location,
    'scheduledAt': scheduledAt?.toIso8601String(),
  };

  factory AppNotificationModel.fromEntity(AppNotification n) =>
      AppNotificationModel(
        id: n.id,
        type: n.type,
        title: n.title,
        body: n.body,
        createdAt: n.createdAt,
        isRead: n.isRead,
        requestId: n.requestId,
        clientName: n.clientName,
        serviceName: n.serviceName,
        location: n.location,
        scheduledAt: n.scheduledAt,
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1';
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } on FormatException {
        // ignore: empty_catches
      }
    }
    return const <String, dynamic>{};
  }

  static AppNotificationType _typeFromCode(String? code) {
    switch (code) {
      case 'client_request':
        return AppNotificationType.clientRequest;

      case 'new_task_assigned':
      case 'task_assigned':
        return AppNotificationType.taskAssigned;
      case 'task_reminder':
        return AppNotificationType.taskReminder;
      case 'general':
      default:
        return AppNotificationType.general;
    }
  }

  static String typeCode(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.clientRequest:
        return 'client_request';
      case AppNotificationType.taskAssigned:
        return 'task_assigned';
      case AppNotificationType.taskReminder:
        return 'task_reminder';
      case AppNotificationType.general:
        return 'general';
    }
  }
}
