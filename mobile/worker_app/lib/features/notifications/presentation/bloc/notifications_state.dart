part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error, markReadFailure }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final Failure? error;

  final Set<String> markingReadIds;
  final int currentPage;
  final bool hasMore;
  final bool loadingMore;
  final Failure? loadMoreError;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.error,
    this.markingReadIds = const {},
    this.currentPage = 1,
    this.hasMore = false,
    this.loadingMore = false,
    this.loadMoreError,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    Failure? error,
    Set<String>? markingReadIds,
    int? currentPage,
    bool? hasMore,
    bool? loadingMore,
    Failure? loadMoreError,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: error,
      markingReadIds: markingReadIds ?? this.markingReadIds,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
      loadMoreError: loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    error,
    markingReadIds,
    currentPage,
    hasMore,
    loadingMore,
    loadMoreError,
  ];
}
