import 'dart:async';

/// The single, app-lifetime path used to ask the daily-tasks list to reload
/// from its source of truth (the tasks repository).
///
/// Every "the worker's tasks may have changed on the server" trigger funnels
/// into [requestRefresh] instead of each screen reloading on its own:
///  - a notification tap — foreground/in-app, background, or terminated
///    (cold start) — routed through `openTaskById`;
///  - (the foreground-push, no-tap case is handled directly by [TasksBloc]
///    listening to `NotificationService.onPushReceived`).
///
/// It is deliberately framework-free — no Firebase, no BLoC — so the
/// notification layer only ever *reacts* into here and never needs changing.
///
/// Cold start: a refresh requested before any [TasksBloc] is listening (the
/// terminated launch-from-notification is handled before the first frame) is
/// LATCHED as [_pending] and delivered the moment a bloc subscribes and calls
/// [consumePending], so the launch refresh is never lost.
class TasksRefreshSignal {
  TasksRefreshSignal._();

  static final TasksRefreshSignal instance = TasksRefreshSignal._();

  final StreamController<void> _controller = StreamController<void>.broadcast();

  /// A refresh that arrived while nobody was listening yet.
  bool _pending = false;

  /// [TasksBloc] subscribes to this and reloads on each event.
  Stream<void> get stream => _controller.stream;

  /// Ask the daily-tasks list to reload. Delivered now if a bloc is listening;
  /// otherwise remembered for the next [consumePending].
  void requestRefresh() {
    if (_controller.hasListener) {
      _controller.add(null);
    } else {
      _pending = true;
    }
  }

  /// Called by [TasksBloc] right after it subscribes: drains a latched refresh
  /// (the cold-start case) so it fires once the list is ready.
  void consumePending() {
    if (_pending) {
      _pending = false;
      _controller.add(null);
    }
  }
}
