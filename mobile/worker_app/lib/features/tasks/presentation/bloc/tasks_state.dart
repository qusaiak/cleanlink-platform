part of 'tasks_bloc.dart';

enum TasksStatus {
  initial,
  loading,
  loaded,
  error,
  actionLoading,
  actionSuccess,
  actionFailure,
}

enum SummaryStatus { initial, loading, loaded, error }

enum TaskActionType { onWay, start, complete, accept, updateStatus }

class TasksState extends Equatable {
  final TasksStatus status;
  final DailyTasks? daily;
  final TodayTaskSummary? summary;
  final SummaryStatus summaryStatus;
  final Failure? summaryError;

  final TaskStatus? filter;
  final Failure? error;

  final TaskActionType? lastAction;
  final String? actingTaskId;

  const TasksState({
    this.status = TasksStatus.initial,
    this.daily,
    this.summary,
    this.summaryStatus = SummaryStatus.initial,
    this.summaryError,
    this.filter,
    this.error,
    this.lastAction,
    this.actingTaskId,
  });

  List<Task> get visibleTasks {
    final all = daily?.tasks ?? const <Task>[];
    final visible = filter == null
        ? List<Task>.from(all)
        : all.where((task) => task.status == filter).toList();
    visible.sort((a, b) {
      if (filter == TaskStatus.completed) {
        return b.scheduledAt.compareTo(a.scheduledAt);
      }
      if (filter == null && a.status != b.status) {
        return TaskStatusProgression.sequence
            .indexOf(a.status)
            .compareTo(TaskStatusProgression.sequence.indexOf(b.status));
      }
      return a.scheduledAt.compareTo(b.scheduledAt);
    });
    return visible;
  }

  static const Object _undefined = Object();

  TasksState copyWith({
    TasksStatus? status,
    DailyTasks? daily,
    TodayTaskSummary? summary,
    SummaryStatus? summaryStatus,
    Failure? summaryError,
    bool clearSummaryError = false,
    Object? filter = _undefined,
    Failure? error,
    TaskActionType? lastAction,
    String? actingTaskId,
  }) {
    return TasksState(
      status: status ?? this.status,
      daily: daily ?? this.daily,
      summary: summary ?? this.summary,
      summaryStatus: summaryStatus ?? this.summaryStatus,
      summaryError: clearSummaryError
          ? null
          : (summaryError ?? this.summaryError),
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
    summary,
    summaryStatus,
    summaryError,
    filter,
    error,
    lastAction,
    actingTaskId,
  ];
}
