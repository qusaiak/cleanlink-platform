part of 'tasks_bloc.dart';

/// High-level state of the daily-tasks screen.
///
/// The `action*` values are transient and used to drive snackbars from a
/// `BlocListener` after a worker action, without losing the loaded list.
enum TasksStatus {
  initial,
  loading,
  loaded,
  error,
  actionLoading,
  actionSuccess,
  actionFailure,
}

/// Which worker action produced an [TasksStatus.actionSuccess]/`actionFailure`,
/// so the UI picks the correct localized message.
enum TaskActionType { start, pause, complete, cancel, accept, updateStatus }

class TasksState extends Equatable {
  final TasksStatus status;
  final DailyTasks? daily;

  /// Active status filter; `null` means "show all".
  final TaskStatus? filter;
  final Failure? error;

  /// The last action and the task it targeted (for the snackbar + per-card
  /// loading spinner).
  final TaskActionType? lastAction;
  final String? actingTaskId;

  const TasksState({
    this.status = TasksStatus.initial,
    this.daily,
    this.filter,
    this.error,
    this.lastAction,
    this.actingTaskId,
  });

  /// Tasks after applying [filter] (all of them when [filter] is null).
  List<Task> get visibleTasks {
    final all = daily?.tasks ?? const <Task>[];
    if (filter == null) return all;
    return all.where((t) => t.status == filter).toList();
  }

  // Sentinel so copyWith can distinguish "leave filter unchanged" from
  // "set filter to null (= all)".
  static const Object _undefined = Object();

  TasksState copyWith({
    TasksStatus? status,
    DailyTasks? daily,
    Object? filter = _undefined,
    Failure? error,
    TaskActionType? lastAction,
    String? actingTaskId,
  }) {
    return TasksState(
      status: status ?? this.status,
      daily: daily ?? this.daily,
      filter: filter == _undefined ? this.filter : filter as TaskStatus?,
      error: error ?? this.error,
      lastAction: lastAction ?? this.lastAction,
      actingTaskId: actingTaskId ?? this.actingTaskId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    daily,
    filter,
    error,
    lastAction,
    actingTaskId,
  ];
}
