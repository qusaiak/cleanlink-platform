part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {
  final bool silent;

  const LoadNotifications({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

class LoadMoreNotifications extends NotificationsEvent {
  const LoadMoreNotifications();
}

class StartNotificationsPolling extends NotificationsEvent {
  const StartNotificationsPolling();
}

class MarkNotificationRead extends NotificationsEvent {
  final String id;

  const MarkNotificationRead(this.id);

  @override
  List<Object?> get props => [id];
}
