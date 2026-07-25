import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/update_task_status_usecase.dart';
import '../../domain/usecases/upload_task_photos_usecase.dart';

part 'task_detail_event.dart';
part 'task_detail_state.dart';

/// Drives the task-detail screen: selecting a target status, attaching
/// before/after photos, and submitting (upload photos → update status).
///
/// Constructed with the [Task] to display (passed via navigation) plus the
/// use cases (from `get_it`), so it has a fully-formed initial state without
/// a separate "load" round-trip.
class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final UpdateTaskStatusUseCase updateTaskStatus;
  final UploadTaskPhotosUseCase uploadTaskPhotos;

  TaskDetailBloc({
    required Task task,
    required this.updateTaskStatus,
    required this.uploadTaskPhotos,
  }) : super(TaskDetailState(task: task, selectedStatus: task.status)) {
    on<StatusSelected>(_onStatusSelected);
    on<PhotoAdded>(_onPhotoAdded);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<DetailSubmitted>(_onSubmitted);
  }

  void _onStatusSelected(StatusSelected event, Emitter<TaskDetailState> emit) {
    emit(
      state.copyWith(
        selectedStatus: event.status,
        status: TaskDetailStatus.initial,
      ),
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
    DetailSubmitted event,
    Emitter<TaskDetailState> emit,
  ) async {
    emit(state.copyWith(status: TaskDetailStatus.submitting));

    var currentTask = state.task;

    // 1) Upload any newly attached photos first.
    if (state.newBeforePhotos.isNotEmpty || state.newAfterPhotos.isNotEmpty) {
      final uploadResult = await uploadTaskPhotos(
        params: UploadTaskPhotosParams(
          taskId: currentTask.id,
          beforePaths: state.newBeforePhotos,
          afterPaths: state.newAfterPhotos,
        ),
      );
      final uploadFailure = uploadResult.fold((f) => f, (_) => null);
      if (uploadFailure != null) {
        emit(
          state.copyWith(
            status: TaskDetailStatus.failure,
            error: uploadFailure,
          ),
        );
        return;
      }
      currentTask = uploadResult.getOrElse(() => currentTask);
    }

    // 2) Apply the selected status.
    final statusResult = await updateTaskStatus(
      params: UpdateTaskStatusParams(
        taskId: currentTask.id,
        status: state.selectedStatus,
      ),
    );

    statusResult.fold(
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
