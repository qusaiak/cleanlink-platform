part of 'task_detail_bloc.dart';

/// Lifecycle of a submit on the task-detail screen.
enum TaskDetailStatus { initial, submitting, success, failure }

class TaskDetailState extends Equatable {
  /// The task being viewed/edited (updated after a successful submit).
  final Task task;

  /// Currently chosen status in the radio list (defaults to the task's status).
  final TaskStatus selectedStatus;

  /// Local file paths picked but not yet uploaded, per documentation slot.
  final List<String> newBeforePhotos;
  final List<String> newAfterPhotos;

  final TaskDetailStatus status;
  final Failure? error;

  const TaskDetailState({
    required this.task,
    required this.selectedStatus,
    this.newBeforePhotos = const [],
    this.newAfterPhotos = const [],
    this.status = TaskDetailStatus.initial,
    this.error,
  });

  TaskDetailState copyWith({
    Task? task,
    TaskStatus? selectedStatus,
    List<String>? newBeforePhotos,
    List<String>? newAfterPhotos,
    TaskDetailStatus? status,
    Failure? error,
    bool clearNewPhotos = false,
  }) {
    return TaskDetailState(
      task: task ?? this.task,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      newBeforePhotos:
          clearNewPhotos ? const [] : (newBeforePhotos ?? this.newBeforePhotos),
      newAfterPhotos:
          clearNewPhotos ? const [] : (newAfterPhotos ?? this.newAfterPhotos),
      status: status ?? this.status,
      // Error is intentionally not carried over: it's only set on failure.
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    task,
    selectedStatus,
    newBeforePhotos,
    newAfterPhotos,
    status,
    error,
  ];
}
