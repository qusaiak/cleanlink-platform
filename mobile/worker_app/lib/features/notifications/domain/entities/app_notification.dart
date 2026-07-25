import 'package:equatable/equatable.dart';

/// The kind of a notification, used to pick an icon/accent and to route the
/// worker to the right place when a notification is tapped.
///
/// - [clientRequest] → a client requested a worker for a service while this
///   worker is scheduled as available (the headline use case).
/// - [taskAssigned]  → a task was assigned to the worker.
/// - [taskReminder]  → an upcoming/scheduled task reminder.
/// - [general]       → announcements / everything else.
enum AppNotificationType { clientRequest, taskAssigned, taskReminder, general }

/// A single entry in the worker's notification feed.
///
/// Pure domain entity (only [Equatable]); no Flutter/data dependencies. The
/// optional `request*` / `client*` / `service*` fields carry the context of a
/// [AppNotificationType.clientRequest] so the UI can show who requested what,
/// where and when.
class AppNotification extends Equatable {
  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  /// Context for a client-request notification (all nullable — only present on
  /// [AppNotificationType.clientRequest]).
  final String? requestId;
  final String? clientName;
  final String? serviceName;
  final String? location;
  final DateTime? scheduledAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.requestId,
    this.clientName,
    this.serviceName,
    this.location,
    this.scheduledAt,
  });

  /// Returns a copy with [isRead] overridden (used after marking read).
  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      requestId: requestId,
      clientName: clientName,
      serviceName: serviceName,
      location: location,
      scheduledAt: scheduledAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    createdAt,
    isRead,
    requestId,
    clientName,
    serviceName,
    location,
    scheduledAt,
  ];
}
