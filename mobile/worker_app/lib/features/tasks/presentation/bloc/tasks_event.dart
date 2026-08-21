part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyTasks extends TasksEvent {
  const LoadDailyTasks();
}

class LoadTodayTaskSummary extends TasksEvent {
  const LoadTodayTaskSummary();
}

class FilterTasksByStatus extends TasksEvent {
  final TaskStatus? status;

  const FilterTasksByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

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

class _DailyTasksSynced extends TasksEvent {
  final DailyTasks daily;

  const _DailyTasksSynced(this.daily);

  @override
  List<Object?> get props => [daily];
}
