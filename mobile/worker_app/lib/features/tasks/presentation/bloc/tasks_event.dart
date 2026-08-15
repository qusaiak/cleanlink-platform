part of 'tasks_bloc.dart';

/// Events the daily-tasks screen can dispatch. Sealed to match the project's
/// bloc style (see `AuthEvent`).
sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or refresh) the worker's daily tasks + header stats.
class LoadDailyTasks extends TasksEvent {
  const LoadDailyTasks();
}

/// Filter the visible list by [status]; `null` shows all tasks.
class FilterTasksByStatus extends TasksEvent {
  final TaskStatus? status;

  const FilterTasksByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Advance a task from [currentStatus] to [newStatus] (must be the single
/// next step of the sequence — validated by the use case before any request).
/// [action] records which worker action triggered it so the UI can show the
/// matching success/failure snackbar.
class ChangeTaskStatus extends TasksEvent {
  final String taskId;
  final TaskStatus currentStatus;
  final TaskStatus newStatus;
  final TaskActionType action;

  const ChangeTaskStatus({
    required this.taskId,
    required this.currentStatus,
    required this.newStatus,
    required this.action,
  });

  @override
  List<Object?> get props => [taskId, currentStatus, newStatus, action];
}

/// Internal: the repository's task cache (the single source of truth) emitted a
/// new [daily]. Dispatched by the bloc's own stream subscription — never from
/// the UI — so the list rebuilds whenever the shared store changes.
class _DailyTasksSynced extends TasksEvent {
  final DailyTasks daily;

  const _DailyTasksSynced(this.daily);

  @override
  List<Object?> get props => [daily];
}
