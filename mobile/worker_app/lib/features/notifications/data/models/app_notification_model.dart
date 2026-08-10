import 'dart:convert';

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

  /// Parses one entry of `GET /api/notifications`:
  /// `{id, title, body, is_read, created_at, data: {type, order_id, status}}`
  /// — the notification's type and the order it points to live in the nested
  /// `data` object. Flat payloads (the in-memory mock, older shapes) keep
  /// working through the fallback keys.
  ///
  /// Every field is read defensively: the server's column types are not
  /// guaranteed to survive JSON (a `tinyint(1)` can arrive as `0`/`1` rather
  /// than a real boolean if the model's cast is ever dropped, and a `json`
  /// column can arrive as an encoded string), and a hard cast on any one of
  /// them would abort the whole feed. Only a MISSING ID throws — an item that
  /// cannot be identified also cannot be marked read, so the caller skips it.
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
      // A task-assignment notification carries the order it refers to as
      // `data.order_id` — kept as [requestId] so tapping it opens that task.
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

  // ---- defensive field readers ----

  /// Never throws: an unparsable timestamp becomes `null` (the caller
  /// substitutes the epoch) instead of killing the entry, so the newest-first
  /// sort still has a total order to work with.
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  /// Accepts every shape "read" realistically arrives in: a real boolean, the
  /// `0`/`1` a `tinyint(1)` produces without an Eloquent cast, and their string
  /// forms. Anything unrecognised counts as unread — the safe default, since it
  /// leaves the item visible and actionable rather than hiding it.
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1';
  }

  /// The `data` column is a `json` column cast to an array server-side, so it
  /// normally arrives as an object — but it decodes to a plain [String] if that
  /// cast is ever removed, which would silently drop `order_id` and make every
  /// notification untappable. Both forms are accepted.
  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } on FormatException {
        // Not JSON after all — fall through to the empty map.
      }
    }
    return const <String, dynamic>{};
  }

  // ---- enum <-> string code mapping (contract kept in one place) ----

  static AppNotificationType _typeFromCode(String? code) {
    switch (code) {
      case 'client_request':
        return AppNotificationType.clientRequest;
      // `new_task_assigned` is the live backend's code for a task assignment.
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
