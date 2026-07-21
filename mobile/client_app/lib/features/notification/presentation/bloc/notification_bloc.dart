import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/error/failure.dart';
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
    emit(
      state.copyWith(
        isLoadingNotifications: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
        notifications: [],
      ),
    );

    try {
      final notifications = await _getNotificationsUseCase();
      final unreadCount = notifications.where((item) => !item.isRead).length;
      emit(
        state.copyWith(
          notifications: notifications,
          unreadCount: unreadCount,
          isLoadingNotifications: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingNotifications: false,
          errorMessage: _messageFromError(e),
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

    final orderId = event.notification.orderId;
    if (orderId != null) {
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

    if (event.orderId != null) {
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
      emit(
        state.copyWith(
          notifications: previousNotifications,
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
}
