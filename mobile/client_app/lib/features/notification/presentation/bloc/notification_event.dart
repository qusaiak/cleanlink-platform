part of 'notification_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

final class SyncFcmTokenEvent extends NotificationsEvent {
  final String fcmToken;
  final String deviceType;
  final String lang;

  const SyncFcmTokenEvent({
    required this.fcmToken,
    required this.deviceType,
    required this.lang,
  });

  @override
  List<Object?> get props => [fcmToken, deviceType, lang];
}

final class GetNotificationsEvent extends NotificationsEvent {
  const GetNotificationsEvent();
}

final class GetUnreadNotificationsCountEvent extends NotificationsEvent {
  final bool silent;

  const GetUnreadNotificationsCountEvent({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

final class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int notificationId;

  const MarkNotificationAsReadEvent({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

final class NotificationClickedEvent extends NotificationsEvent {
  final AppNotificationEntity notification;

  const NotificationClickedEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

final class NotificationTappedFromPushEvent extends NotificationsEvent {
  final int? notificationId;
  final int? orderId;
  final String? type;

  const NotificationTappedFromPushEvent({
    this.notificationId,
    this.orderId,
    this.type,
  });

  @override
  List<Object?> get props => [notificationId, orderId, type];
}

final class NewNotificationReceivedEvent extends NotificationsEvent {
  const NewNotificationReceivedEvent();
}

final class ClearNotificationsMessageEvent extends NotificationsEvent {
  const ClearNotificationsMessageEvent();
}
