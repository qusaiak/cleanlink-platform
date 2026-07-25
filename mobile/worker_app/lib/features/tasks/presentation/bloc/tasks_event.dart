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

/// Transition a task to [newStatus]. [action] records which worker action
/// triggered it so the UI can show the matching success/failure snackbar.
class ChangeTaskStatus extends TasksEvent {
  final String taskId;
  final TaskStatus newStatus;
  final TaskActionType action;

  const ChangeTaskStatus({
    required this.taskId,
    required this.newStatus,
    required this.action,
  });

  @override
  List<Object?> get props => [taskId, newStatus, action];
}
