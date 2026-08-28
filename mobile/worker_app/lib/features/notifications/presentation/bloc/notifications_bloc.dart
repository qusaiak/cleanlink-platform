import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../services/notification_service.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState>
    with WidgetsBindingObserver {
  static const Duration pollInterval = Duration(seconds: 30);

  final GetNotificationsUseCase getNotifications;
  final MarkNotificationReadUseCase markRead;
  final MarkAllNotificationsReadUseCase markAllRead;

  Timer? _pollTimer;

  StreamSubscription<void>? _pushSub;

  NotificationsBloc({
    required this.getNotifications,
    required this.markRead,
    required this.markAllRead,
  }) : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoad);
    on<LoadMoreNotifications>(_onLoadMore);
    on<StartNotificationsPolling>(_onStartPolling);
    on<MarkNotificationRead>(_onMarkRead);

    _pushSub = NotificationService.instance.onPushReceived.listen((_) {
      if (!isClosed) add(const LoadNotifications(silent: true));
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isClosed) {
      add(const LoadNotifications(silent: true));
    }
  }

  @override
  Future<void> close() {
    _pushSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(status: NotificationsStatus.loading));
    }
    final result = await getNotifications();
    result.fold(
      (failure) {
        if (!event.silent || state.notifications.isEmpty) {
          emit(
            state.copyWith(status: NotificationsStatus.error, error: failure),
          );
        }
      },
      (page) => emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: page.items,
          currentPage: page.currentPage,
          hasMore: page.hasMore,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (!state.hasMore || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));
    final result = await getNotifications(
      params: GetNotificationsParams(page: state.currentPage + 1),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(loadingMore: false, loadMoreError: failure)),
      (page) {
        final merged = <String, AppNotification>{
          for (final item in state.notifications) item.id: item,
          for (final item in page.items) item.id: item,
        }.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(
          state.copyWith(
            notifications: merged,
            currentPage: page.currentPage,
            hasMore: page.hasMore,
            loadingMore: false,
          ),
        );
      },
    );
  }

  void _onStartPolling(
    StartNotificationsPolling event,
    Emitter<NotificationsState> emit,
  ) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(pollInterval, (_) {
      if (!isClosed) add(const LoadNotifications(silent: true));
    });
  }

  Future<void> _onMarkRead(
    MarkNotificationRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state.markingReadIds.contains(event.id)) return;
    final index = state.notifications.indexWhere((n) => n.id == event.id);
    if (index == -1 || state.notifications[index].isRead) return;

    emit(
      state.copyWith(
        status: NotificationsStatus.loaded,
        markingReadIds: {...state.markingReadIds, event.id},
      ),
    );

    final result = await markRead(params: event.id);
    final remaining = {...state.markingReadIds}..remove(event.id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.markReadFailure,
            error: failure,
            markingReadIds: remaining,
          ),
        );
        emit(
          state.copyWith(
            status: NotificationsStatus.loaded,
            markingReadIds: remaining,
          ),
        );
      },
      (_) => emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: [
            for (final n in state.notifications)
              n.id == event.id ? n.copyWith(isRead: true) : n,
          ],
          markingReadIds: remaining,
        ),
      ),
    );
  }
}
