part of 'task_detail_bloc.dart';

sealed class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskDetails extends TaskDetailEvent {
  const LoadTaskDetails();
}

class PhotoAdded extends TaskDetailEvent {
  final String path;
  final bool isBefore;

  const PhotoAdded({required this.path, required this.isBefore});

  @override
  List<Object?> get props => [path, isBefore];
}

class PhotoRemoved extends TaskDetailEvent {
  final int index;
  final bool isBefore;

  const PhotoRemoved({required this.index, required this.isBefore});

  @override
  List<Object?> get props => [index, isBefore];
}

class AdvanceStatusSubmitted extends TaskDetailEvent {
  const AdvanceStatusSubmitted();
}
