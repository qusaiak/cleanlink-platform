part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error, markReadFailure }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final Failure? error;

  final Set<String> markingReadIds;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.error,
    this.markingReadIds = const {},
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    Failure? error,
    Set<String>? markingReadIds,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: error,
      markingReadIds: markingReadIds ?? this.markingReadIds,
    );
  }

  @override
  List<Object?> get props => [status, notifications, error, markingReadIds];
}
