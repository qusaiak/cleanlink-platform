part of 'task_detail_bloc.dart';

/// Lifecycle of a submit on the task-detail screen.
enum TaskDetailStatus { initial, submitting, success, failure }

class TaskDetailState extends Equatable {
  /// The task being viewed/edited (updated after a successful submit).
  final Task task;

  /// Local file paths picked but not yet uploaded, per documentation slot.
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

  /// The single status the task may advance to next (strictly sequential),
  /// or `null` when the task is done / outside the sequence.
  TaskStatus? get nextStatus => task.status.next;

  /// Whether the upcoming step is `done` — the only step where the before/
  /// after photo pickers are shown and images are sent.
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
      // Error is intentionally not carried over: it's only set on failure.
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
