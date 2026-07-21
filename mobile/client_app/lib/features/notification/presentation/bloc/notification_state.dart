part of 'notification_bloc.dart';

class NotificationsState extends Equatable {
  final List<AppNotificationEntity> notifications;
  final bool isLoadingNotifications;
  final bool isLoadingUnreadCount;
  final bool isSyncingFcmToken;
  final bool isMarkingAsRead;
  final String? errorMessage;
  final String? successMessage;
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.isLoadingNotifications = false,
    this.isLoadingUnreadCount = false,
    this.isSyncingFcmToken = false,
    this.isMarkingAsRead = false,
    this.errorMessage,
    this.successMessage,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<AppNotificationEntity>? notifications,
    bool? isLoadingNotifications,
    bool? isLoadingUnreadCount,
    bool? isSyncingFcmToken,
    bool? isMarkingAsRead,
    String? errorMessage,
    String? successMessage,
    int? unreadCount,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoadingNotifications:
          isLoadingNotifications ?? this.isLoadingNotifications,
      isLoadingUnreadCount: isLoadingUnreadCount ?? this.isLoadingUnreadCount,
      isSyncingFcmToken: isSyncingFcmToken ?? this.isSyncingFcmToken,
      isMarkingAsRead: isMarkingAsRead ?? this.isMarkingAsRead,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    isLoadingNotifications,
    isLoadingUnreadCount,
    isSyncingFcmToken,
    isMarkingAsRead,
    errorMessage,
    successMessage,
    unreadCount,
  ];
}
