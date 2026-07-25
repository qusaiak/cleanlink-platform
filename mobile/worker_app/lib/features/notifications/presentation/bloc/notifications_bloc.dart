import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Drives the notifications feed and the top-bar unread badge: loads the feed,
/// marks one/all read. The unread count is derived in the state so the badge
/// stays in sync with the list automatically.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationReadUseCase markRead;
  final MarkAllNotificationsReadUseCase markAllRead;

  NotificationsBloc({
    required this.getNotifications,
    required this.markRead,
    required this.markAllRead,
  }) : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoad);
    on<MarkNotificationRead>(_onMarkRead);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await getNotifications();
    result.fold(
      (failure) => emit(
        state.copyWith(status: NotificationsStatus.error, error: failure),
      ),
      (items) => emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: items,
        ),
      ),
    );
  }

  Future<void> _onMarkRead(
    MarkNotificationRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await markRead(params: event.id);
    result.fold(
      (failure) => emit(state.copyWith(error: failure)),
      (updated) {
        final next = state.notifications
            .map((n) => n.id == updated.id ? updated : n)
            .toList();
        emit(
          state.copyWith(
            status: NotificationsStatus.loaded,
            notifications: next,
          ),
        );
      },
    );
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await markAllRead();
    result.fold(
      (failure) => emit(state.copyWith(error: failure)),
      (items) => emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: items,
        ),
      ),
    );
  }
}
