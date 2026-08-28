import 'package:equatable/equatable.dart';

enum AppNotificationType { taskAssigned, taskUpdated, general }

class NotificationsPageResult {
  final List<AppNotification> items;
  final int currentPage;
  final bool hasMore;

  const NotificationsPageResult({
    required this.items,
    required this.currentPage,
    required this.hasMore,
  });
}

class AppNotification extends Equatable {
  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

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
