part of 'notification_bloc.dart';

class NotificationsState extends Equatable {
  final List<AppNotificationEntity> notifications;
  final bool isLoadingNotifications;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool isLoadingUnreadCount;
  final bool isSyncingFcmToken;
  final bool isMarkingAsRead;
  final String? errorMessage;
  final String? notificationsError;
  final String? successMessage;
  final String? loadMoreError;
  final int unreadCount;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const NotificationsState({
    this.notifications = const [],
    this.isLoadingNotifications = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isLoadingUnreadCount = false,
    this.isSyncingFcmToken = false,
    this.isMarkingAsRead = false,
    this.errorMessage,
    this.notificationsError,
    this.successMessage,
    this.loadMoreError,
    this.unreadCount = 0,
    this.currentPage = 0,
    this.perPage = PaginationConstants.notificationsPageSize,
    this.total = 0,
    this.lastPage = 1,
    this.hasMorePages = true,
  });

  NotificationsState copyWith({
    List<AppNotificationEntity>? notifications,
    bool? isLoadingNotifications,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? isLoadingUnreadCount,
    bool? isSyncingFcmToken,
    bool? isMarkingAsRead,
    String? errorMessage,
    String? notificationsError,
    String? successMessage,
    String? loadMoreError,
    int? unreadCount,
    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
    bool? hasMorePages,
    bool clearErrorMessage = false,
    bool clearNotificationsError = false,
    bool clearSuccessMessage = false,
    bool clearLoadMoreError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoadingNotifications:
          isLoadingNotifications ?? this.isLoadingNotifications,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingUnreadCount: isLoadingUnreadCount ?? this.isLoadingUnreadCount,
      isSyncingFcmToken: isSyncingFcmToken ?? this.isSyncingFcmToken,
      isMarkingAsRead: isMarkingAsRead ?? this.isMarkingAsRead,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      notificationsError: clearNotificationsError
          ? null
          : notificationsError ?? this.notificationsError,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
      unreadCount: unreadCount ?? this.unreadCount,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    isLoadingNotifications,
    isLoadingMore,
    isRefreshing,
    isLoadingUnreadCount,
    isSyncingFcmToken,
    isMarkingAsRead,
    errorMessage,
    notificationsError,
    successMessage,
    loadMoreError,
    unreadCount,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
  ];
}
