part of 'notifications_bloc.dart';

/// [markReadFailure] is transient: emitted (with [NotificationsState.error])
/// when a mark-as-read request fails so the page can show a snackbar, then
/// immediately followed by [loaded].
enum NotificationsStatus { initial, loading, loaded, error, markReadFailure }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final Failure? error;

  /// Ids whose mark-as-read request is currently in flight — drives the small
  /// loading indicator on that notification's button.
  final Set<String> markingReadIds;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.error,
    this.markingReadIds = const {},
  });

  /// Number of unread notifications — drives the top-bar badge.
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
