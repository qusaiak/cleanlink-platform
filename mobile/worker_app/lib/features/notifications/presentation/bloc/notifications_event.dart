part of 'notifications_bloc.dart';

/// Events for the notifications feature.
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or refresh) the notification feed.
class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

/// Mark a single notification read (by id).
class MarkNotificationRead extends NotificationsEvent {
  final String id;

  const MarkNotificationRead(this.id);

  @override
  List<Object?> get props => [id];
}

/// Mark every notification read.
class MarkAllNotificationsRead extends NotificationsEvent {
  const MarkAllNotificationsRead();
}
