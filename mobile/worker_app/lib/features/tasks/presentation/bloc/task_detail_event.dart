part of 'task_detail_bloc.dart';

/// Events for the task-detail screen.
sealed class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();

  @override
  List<Object?> get props => [];
}

/// The worker picked a new target status from the radio list.
class StatusSelected extends TaskDetailEvent {
  final TaskStatus status;

  const StatusSelected(this.status);

  @override
  List<Object?> get props => [status];
}

/// A photo was captured/picked for the before ([isBefore] = true) or after
/// documentation slot. [path] is the local file path.
class PhotoAdded extends TaskDetailEvent {
  final String path;
  final bool isBefore;

  const PhotoAdded({required this.path, required this.isBefore});

  @override
  List<Object?> get props => [path, isBefore];
}

/// Remove a not-yet-uploaded photo from a slot.
class PhotoRemoved extends TaskDetailEvent {
  final int index;
  final bool isBefore;

  const PhotoRemoved({required this.index, required this.isBefore});

  @override
  List<Object?> get props => [index, isBefore];
}

/// Submit: upload any newly attached photos, then apply the selected status.
class DetailSubmitted extends TaskDetailEvent {
  const DetailSubmitted();
}
