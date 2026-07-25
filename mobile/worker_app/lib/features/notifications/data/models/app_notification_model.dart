import '../../domain/entities/app_notification.dart';

/// Data-layer representation of [AppNotification]. Extends the entity so it can
/// be used anywhere a notification is expected, while adding JSON
/// (de)serialization. The [type] maps to/from stable string codes shared with
/// the backend contract.
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
    DateTime? parseDate(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());

    return AppNotificationModel(
      id: json['id'].toString(),
      type: _typeFromCode(json['type']?.toString()),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? json['message'] ?? '').toString(),
      createdAt:
          parseDate(json['createdAt'] ?? json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isRead: json['isRead'] ?? json['is_read'] ?? false,
      requestId: (json['requestId'] ?? json['request_id'])?.toString(),
      clientName: (json['clientName'] ?? json['client_name'])?.toString(),
      serviceName: (json['serviceName'] ?? json['service_name'])?.toString(),
      location: json['location']?.toString(),
      scheduledAt: parseDate(json['scheduledAt'] ?? json['scheduled_at']),
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

  /// Builds a model from a domain [AppNotification] (used by the fake source
  /// and when echoing locally-updated notifications back through the layers).
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

  // ---- enum <-> string code mapping (contract kept in one place) ----

  static AppNotificationType _typeFromCode(String? code) {
    switch (code) {
      case 'client_request':
        return AppNotificationType.clientRequest;
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
