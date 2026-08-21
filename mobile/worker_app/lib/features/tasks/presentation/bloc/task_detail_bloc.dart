import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_task_by_id_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';

part 'task_detail_event.dart';
part 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final UpdateTaskStatusUseCase updateTaskStatus;
  final GetTaskByIdUseCase getTaskById;

  TaskDetailBloc({
    required Task task,
    required this.updateTaskStatus,
    required this.getTaskById,
  }) : super(TaskDetailState(task: task)) {
    on<LoadTaskDetails>(_onLoad);
    on<PhotoAdded>(_onPhotoAdded);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<AdvanceStatusSubmitted>(_onSubmitted);
    if (task.id.isNotEmpty) add(const LoadTaskDetails());
  }

  Future<void> _onLoad(
    LoadTaskDetails event,
    Emitter<TaskDetailState> emit,
  ) async {
    if (state.task.id.isEmpty) return;
    emit(state.copyWith(status: TaskDetailStatus.loading));
    final result = await getTaskById(params: state.task.id);
    result.fold(
      (failure) => emit(
        state.copyWith(status: TaskDetailStatus.loadFailure, error: failure),
      ),
      (task) =>
          emit(state.copyWith(status: TaskDetailStatus.loaded, task: task)),
    );
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
    final target = state.nextStatus;
    if (target == null) return;

    emit(state.copyWith(status: TaskDetailStatus.submitting));

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

    Failure? failure;
    Task? updated;
    result.fold((value) => failure = value, (value) => updated = value);
    if (failure != null) {
      emit(state.copyWith(status: TaskDetailStatus.failure, error: failure));
      return;
    }

    var latest = updated!;
    final refreshed = await getTaskById(params: latest.id);
    refreshed.fold((_) {}, (task) => latest = task);
    emit(
      state.copyWith(
        status: TaskDetailStatus.success,
        task: latest,
        clearNewPhotos: true,
      ),
    );
  }
}
