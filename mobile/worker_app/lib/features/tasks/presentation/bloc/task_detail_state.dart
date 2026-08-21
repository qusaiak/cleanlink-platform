part of 'task_detail_bloc.dart';

enum TaskDetailStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  failure,
  loadFailure,
}

class TaskDetailState extends Equatable {
  final Task task;

  final List<String> newBeforePhotos;
  final List<String> newAfterPhotos;

  final TaskDetailStatus status;
  final Failure? error;

  const TaskDetailState({
    required this.task,
    this.newBeforePhotos = const [],
    this.newAfterPhotos = const [],
    this.status = TaskDetailStatus.initial,
    this.error,
  });

  TaskStatus? get nextStatus => task.status.next;

  bool get isMarkingDone => nextStatus == TaskStatus.completed;

  TaskDetailState copyWith({
    Task? task,
    List<String>? newBeforePhotos,
    List<String>? newAfterPhotos,
    TaskDetailStatus? status,
    Failure? error,
    bool clearNewPhotos = false,
  }) {
    return TaskDetailState(
      task: task ?? this.task,
      newBeforePhotos: clearNewPhotos
          ? const []
          : (newBeforePhotos ?? this.newBeforePhotos),
      newAfterPhotos: clearNewPhotos
          ? const []
          : (newAfterPhotos ?? this.newAfterPhotos),
      status: status ?? this.status,

      error: error,
    );
  }

  @override
  List<Object?> get props => [
    task,
    newBeforePhotos,
    newAfterPhotos,
    status,
    error,
  ];
}
