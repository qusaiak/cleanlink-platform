import 'dart:async';

class TasksRefreshSignal {
  TasksRefreshSignal._();

  static final TasksRefreshSignal instance = TasksRefreshSignal._();

  final StreamController<void> _controller = StreamController<void>.broadcast();

  bool _pending = false;

  Stream<void> get stream => _controller.stream;

  void requestRefresh() {
    if (_controller.hasListener) {
      _controller.add(null);
    } else {
      _pending = true;
    }
  }

  void consumePending() {
    if (_pending) {
      _pending = false;
      _controller.add(null);
    }
  }
}
