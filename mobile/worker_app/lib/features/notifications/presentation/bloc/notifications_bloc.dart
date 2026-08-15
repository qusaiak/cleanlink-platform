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

/// Drives the notifications feed and the top-bar unread badge: loads the feed
/// (once, or periodically via [StartNotificationsPolling]) and marks single
/// notifications read. The unread count is derived in the state so the badge
/// stays in sync with the list automatically.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState>
    with WidgetsBindingObserver {
  /// How often the feed is re-fetched while polling is active. Kept modest so
  /// the badge stays near-live without hammering the backend.
  static const Duration pollInterval = Duration(seconds: 30);

  final GetNotificationsUseCase getNotifications;
  final MarkNotificationReadUseCase markRead;
  final MarkAllNotificationsReadUseCase markAllRead;

  Timer? _pollTimer;

  /// Silent-refetch trigger fired whenever a foreground push arrives.
  StreamSubscription<void>? _pushSub;

  NotificationsBloc({
    required this.getNotifications,
    required this.markRead,
    required this.markAllRead,
  }) : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoad);
    on<StartNotificationsPolling>(_onStartPolling);
    on<MarkNotificationRead>(_onMarkRead);

    // Live unread count: refetch the instant a foreground push arrives, and
    // reconcile whenever the app returns to the foreground (covers a push that
    // arrived while backgrounded, which can't move the badge in real time).
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
    // A silent load (poll tick / refresh-on-return) keeps the current list on
    // screen instead of flashing the loading skeleton.
    if (!event.silent) {
      emit(state.copyWith(status: NotificationsStatus.loading));
    }
    final result = await getNotifications();
    result.fold(
      (failure) {
        // A failed poll shouldn't wipe an already-loaded feed with an error
        // screen; only a foreground load surfaces it.
        if (!event.silent || state.notifications.isEmpty) {
          emit(
            state.copyWith(status: NotificationsStatus.error, error: failure),
          );
        }
      },
      (items) => emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: items,
        ),
      ),
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
    // Ignore double-taps and notifications that are already read.
    if (state.markingReadIds.contains(event.id)) return;
    final index = state.notifications.indexWhere((n) => n.id == event.id);
    if (index == -1 || state.notifications[index].isRead) return;

    // Show the per-button spinner while the request runs.
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
        // Transient failure status → the page shows a snackbar, then the
        // state settles back to loaded with the item still unread.
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
        // Server confirmed → flip the local read flag; the unread badge
        // (derived from the list) decreases automatically.
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
