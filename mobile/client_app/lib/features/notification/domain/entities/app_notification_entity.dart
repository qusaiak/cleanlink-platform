import 'package:equatable/equatable.dart';

class AppNotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;
  final int? orderId;
  final String? type;
  final String? status;

  const AppNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.createdAt,
    this.orderId,
    this.type,
    this.status,
  });

  AppNotificationEntity copyWith({
    int? id,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
    int? orderId,
    String? type,
    String? status,
  }) {
    return AppNotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      orderId: orderId ?? this.orderId,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    isRead,
    createdAt,
    orderId,
    type,
    status,
  ];
}
