import 'dart:async';

import 'package:client_app/config/constants/pagination_constants.dart';
import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/error/failure.dart';
import 'package:client_app/core/pagination/pagination_utils.dart';
import 'package:client_app/features/notification/domain/entities/app_notification_entity.dart';
import 'package:client_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:client_app/features/notification/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:client_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:client_app/features/notification/domain/usecases/update_fcm_token_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final UpdateFcmTokenUseCase _updateFcmTokenUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetUnreadNotificationsCountUseCase _getUnreadNotificationsCountUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;

  NotificationsBloc(
    this._updateFcmTokenUseCase,
    this._getNotificationsUseCase,
    this._getUnreadNotificationsCountUseCase,
    this._markNotificationAsReadUseCase,
  ) : super(const NotificationsState()) {
    on<SyncFcmTokenEvent>(_onSyncFcmToken);
    on<GetNotificationsEvent>(_onGetNotifications);
    on<GetMoreNotificationsEvent>(_onGetMoreNotifications);
    on<GetUnreadNotificationsCountEvent>(_onGetUnreadNotificationsCount);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<NotificationClickedEvent>(_onNotificationClicked);
    on<NotificationTappedFromPushEvent>(_onNotificationTappedFromPush);
    on<NewNotificationReceivedEvent>(_onNewNotificationReceived);
    on<ClearNotificationsMessageEvent>(_onClearNotificationsMessage);
  }

  Future<void> _onSyncFcmToken(
    SyncFcmTokenEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        isSyncingFcmToken: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      await _updateFcmTokenUseCase(
        UpdateFcmTokenParams(
          fcmToken: event.fcmToken,
          deviceType: event.deviceType,
          lang: event.lang,
        ),
      );
      emit(state.copyWith(isSyncingFcmToken: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSyncingFcmToken: false,
          errorMessage: _messageFromError(e),
        ),
      );
    }
  }

  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state.isLoadingNotifications ||
        (event.refresh && state.isLoadingMore)) {
      _complete(event.completer);
      return;
    }
    emit(
      state.copyWith(
        isLoadingNotifications: true,
        isRefreshing: event.refresh,
        isLoadingMore: false,
        clearErrorMessage: true,
        clearNotificationsError: true,
        clearSuccessMessage: true,
        clearLoadMoreError: true,
        notifications: const [],
        currentPage: 0,
        total: 0,
        lastPage: 1,
        hasMorePages: true,
      ),
    );

    try {
      final result = await _getNotificationsUseCase(
        page: 1,
        perPage: PaginationConstants.notificationsPageSize,
      );
      emit(
        state.copyWith(
          notifications: result.items,
          isLoadingNotifications: false,
          isRefreshing: false,
          currentPage: result.pagination.currentPage,
          perPage: result.pagination.perPage,
          total: result.pagination.total,
          lastPage: result.pagination.lastPage,
          hasMorePages: result.pagination.hasMorePages,
        ),
      );
      add(const GetUnreadNotificationsCountEvent(silent: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingNotifications: false,
          isRefreshing: false,
          notificationsError: _messageFromError(e),
        ),
      );
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onGetMoreNotifications(
    GetMoreNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current.isLoadingNotifications ||
        current.isRefreshing ||
        current.isLoadingMore ||
        !current.hasMorePages ||
        (current.loadMoreError != null && !event.retry)) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    try {
      final result = await _getNotificationsUseCase(
        page: current.currentPage + 1,
        perPage: PaginationConstants.notificationsPageSize,
      );
      final latest = state;
      emit(
        latest.copyWith(
          notifications: mergeWithoutDuplicates(
            latest.notifications,
            result.items,
            (notification) => notification.id,
            mergeExisting: (existing, incoming) =>
                existing.isRead && !incoming.isRead
                ? incoming.copyWith(isRead: true)
                : incoming,
          ),
          isLoadingMore: false,
          currentPage: result.pagination.currentPage,
          perPage: result.pagination.perPage,
          total: result.pagination.total,
          lastPage: result.pagination.lastPage,
          hasMorePages: result.pagination.hasMorePages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          loadMoreError: _messageFromError(e),
        ),
      );
    }
  }

  Future<void> _onGetUnreadNotificationsCount(
    GetUnreadNotificationsCountEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(isLoadingUnreadCount: true, clearErrorMessage: true));
    }

    try {
      final unreadCount = await _getUnreadNotificationsCountUseCase();
      emit(
        state.copyWith(unreadCount: unreadCount, isLoadingUnreadCount: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
          unreadCount: state.unreadCount,
          isLoadingUnreadCount: false,
          errorMessage: event.silent
              ? state.errorMessage
              : _messageFromError(e),
        ),
      );
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await _markNotificationAsRead(event.notificationId, emit);
    add(const GetUnreadNotificationsCountEvent(silent: true));
  }

  Future<void> _onNotificationClicked(
    NotificationClickedEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (!event.notification.isRead) {
      add(MarkNotificationAsReadEvent(notificationId: event.notification.id));
    }

    final complaintId = event.notification.complaintId;
    final orderId = event.notification.orderId;
    if (event.notification.type == 'complaint_response' &&
        complaintId != null) {
      AppRouter.router.push(AppRouter.complaintDetailsPath(complaintId));
    } else if (orderId != null) {
      AppRouter.router.push(AppRouter.orderDetailsPath(orderId));
    } else {
      emit(state.copyWith(successMessage: 'notification_open_failed'));
    }
  }

  Future<void> _onNotificationTappedFromPush(
    NotificationTappedFromPushEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (event.notificationId != null) {
      add(MarkNotificationAsReadEvent(notificationId: event.notificationId!));
    } else {
      add(const GetUnreadNotificationsCountEvent(silent: true));
    }

    if (event.type == 'complaint_response' && event.complaintId != null) {
      await AppRouter.openComplaintDetailsFromExternalNotification(
        event.complaintId!,
      );
    } else if (event.orderId != null) {
      await AppRouter.openOrderDetailsFromExternalNotification(event.orderId!);
    }
  }

  Future<void> _onNewNotificationReceived(
    NewNotificationReceivedEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    add(const GetUnreadNotificationsCountEvent());
  }

  void _onClearNotificationsMessage(
    ClearNotificationsMessageEvent event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(clearErrorMessage: true, clearSuccessMessage: true));
  }

  Future<void> _markNotificationAsRead(
    int notificationId,
    Emitter<NotificationsState> emit,
  ) async {
    final previousNotifications = List<AppNotificationEntity>.from(
      state.notifications,
    );
    final previousUnreadCount = state.unreadCount;
    final index = previousNotifications.indexWhere(
      (item) => item.id == notificationId,
    );
    final existingNotification = index == -1
        ? null
        : previousNotifications[index];
    final shouldOptimisticallyUpdate =
        existingNotification != null && !existingNotification.isRead;

    if (shouldOptimisticallyUpdate) {
      final updated = [...previousNotifications];
      updated[index] = existingNotification.copyWith(isRead: true);
      emit(
        state.copyWith(
          notifications: updated,
          unreadCount: _decrementUnreadCount(previousUnreadCount),
          isMarkingAsRead: true,
          clearErrorMessage: true,
        ),
      );
    } else {
      emit(state.copyWith(isMarkingAsRead: true, clearErrorMessage: true));
    }

    try {
      final markedNotification = await _markNotificationAsReadUseCase(
        MarkNotificationAsReadParams(notificationId: notificationId),
      );
      final latestNotifications = [...state.notifications];
      final latestIndex = latestNotifications.indexWhere(
        (item) => item.id == notificationId,
      );
      if (latestIndex != -1) {
        latestNotifications[latestIndex] = _mergeMarkedNotification(
          latestNotifications[latestIndex],
          markedNotification,
        );
      }
      emit(
        state.copyWith(
          notifications: latestNotifications,
          isMarkingAsRead: false,
        ),
      );
    } catch (e) {
      final latestNotifications = [...state.notifications];
      final latestIndex = latestNotifications.indexWhere(
        (item) => item.id == notificationId,
      );
      if (latestIndex != -1 && existingNotification != null) {
        latestNotifications[latestIndex] = existingNotification;
      }
      emit(
        state.copyWith(
          notifications: latestNotifications,
          unreadCount: previousUnreadCount,
          isMarkingAsRead: false,
          errorMessage: _messageFromError(e),
        ),
      );
    }
  }

  AppNotificationEntity _mergeMarkedNotification(
    AppNotificationEntity current,
    AppNotificationEntity response,
  ) {
    return AppNotificationEntity(
      id: response.id == 0 ? current.id : response.id,
      title: response.title.isEmpty ? current.title : response.title,
      body: response.body.isEmpty ? current.body : response.body,
      isRead: true,
      createdAt: response.createdAt ?? current.createdAt,
      orderId: response.orderId ?? current.orderId,
      type: response.type ?? current.type,
      status: response.status ?? current.status,
    );
  }

  int _decrementUnreadCount(int count) => count <= 0 ? 0 : count - 1;

  String _messageFromError(Object error) {
    if (error is Failure) return error.message;
    return error.toString();
  }

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}
