import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/update_task_status_usecase.dart';

part 'task_detail_event.dart';
part 'task_detail_state.dart';

/// Drives the task-detail screen: attaching before/after photos and advancing
/// the task to the single next status of the strict
/// `pending → on_way → handling → done` sequence.
///
/// Constructed with the [Task] to display (passed via navigation) plus the
/// use case (from `get_it`), so it has a fully-formed initial state without
/// a separate "load" round-trip.
class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final UpdateTaskStatusUseCase updateTaskStatus;

  TaskDetailBloc({required Task task, required this.updateTaskStatus})
    : super(TaskDetailState(task: task)) {
    on<PhotoAdded>(_onPhotoAdded);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<AdvanceStatusSubmitted>(_onSubmitted);
  }

  void _onPhotoAdded(PhotoAdded event, Emitter<TaskDetailState> emit) {
    if (event.isBefore) {
      emit(
        state.copyWith(
          newBeforePhotos: [...state.newBeforePhotos, event.path],
          status: TaskDetailStatus.initial,
        ),
      );
    } else {
      emit(
        state.copyWith(
          newAfterPhotos: [...state.newAfterPhotos, event.path],
          status: TaskDetailStatus.initial,
        ),
      );
    }
  }

  void _onPhotoRemoved(PhotoRemoved event, Emitter<TaskDetailState> emit) {
    final list = List<String>.from(
      event.isBefore ? state.newBeforePhotos : state.newAfterPhotos,
    );
    if (event.index < 0 || event.index >= list.length) return;
    list.removeAt(event.index);
    emit(
      event.isBefore
          ? state.copyWith(
              newBeforePhotos: list,
              status: TaskDetailStatus.initial,
            )
          : state.copyWith(
              newAfterPhotos: list,
              status: TaskDetailStatus.initial,
            ),
    );
  }

  Future<void> _onSubmitted(
    AdvanceStatusSubmitted event,
    Emitter<TaskDetailState> emit,
  ) async {
    // The only status offered is the next one in the sequence; nothing to do
    // at the end of it (or for legacy paused/cancelled tasks).
    final target = state.nextStatus;
    if (target == null) return;

    emit(state.copyWith(status: TaskDetailStatus.submitting));

    // Photos ride along ONLY on the `done` step (contract rule 4); the UI
    // hides the pickers on every other step, and the use case re-validates.
    final sendPhotos = target == TaskStatus.completed;
    final result = await updateTaskStatus(
      params: UpdateTaskStatusParams(
        taskId: state.task.id,
        currentStatus: state.task.status,
        newStatus: target,
        imageBeforePath: sendPhotos && state.newBeforePhotos.isNotEmpty
            ? state.newBeforePhotos.last
            : null,
        imageAfterPath: sendPhotos && state.newAfterPhotos.isNotEmpty
            ? state.newAfterPhotos.last
            : null,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: TaskDetailStatus.failure, error: failure),
      ),
      (updatedTask) => emit(
        state.copyWith(
          status: TaskDetailStatus.success,
          task: updatedTask,
          clearNewPhotos: true,
        ),
      ),
    );
  }
}
