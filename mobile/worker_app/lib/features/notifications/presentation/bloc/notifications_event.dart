part of 'notifications_bloc.dart';

/// Events for the notifications feature.
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or refresh) the notification feed. A [silent] load — used by the
/// polling timer and refresh-on-return — keeps the current list on screen
/// (no loading flash) and never replaces loaded content with an error state.
class LoadNotifications extends NotificationsEvent {
  final bool silent;

  const LoadNotifications({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

/// Begin periodic re-fetching of the feed (every
/// [NotificationsBloc.pollInterval]) so the unread badge stays current. The
/// timer lives and dies with the bloc.
class StartNotificationsPolling extends NotificationsEvent {
  const StartNotificationsPolling();
}

/// Mark a single notification read (by id) via
/// `POST /api/notifications/{id}/mark-as-read`.
class MarkNotificationRead extends NotificationsEvent {
  final String id;

  const MarkNotificationRead(this.id);

  @override
  List<Object?> get props => [id];
}
