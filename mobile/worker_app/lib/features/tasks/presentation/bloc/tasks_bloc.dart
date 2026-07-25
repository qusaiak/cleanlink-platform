import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_daily_tasks_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

/// Drives the daily-tasks screen: loads the list/stats, applies status
/// filters, and performs worker actions (start / pause / complete / …) via
/// the domain use cases.
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetDailyTasksUseCase getDailyTasks;
  final UpdateTaskStatusUseCase updateTaskStatus;

  TasksBloc({required this.getDailyTasks, required this.updateTaskStatus})
    : super(const TasksState()) {
    on<LoadDailyTasks>(_onLoad);
    on<FilterTasksByStatus>(_onFilter);
    on<ChangeTaskStatus>(_onChangeStatus);
  }

  Future<void> _onLoad(LoadDailyTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    final result = await getDailyTasks();
    result.fold(
      (failure) => emit(
        state.copyWith(status: TasksStatus.error, error: failure),
      ),
      (daily) => emit(state.copyWith(status: TasksStatus.loaded, daily: daily)),
    );
  }

  void _onFilter(FilterTasksByStatus event, Emitter<TasksState> emit) {
    // `filter` is passed explicitly (sentinel-aware copyWith) so `null`
    // correctly resets to "show all".
    emit(state.copyWith(status: TasksStatus.loaded, filter: event.status));
  }

  Future<void> _onChangeStatus(
    ChangeTaskStatus event,
    Emitter<TasksState> emit,
  ) async {
    // Mark the targeted card as busy.
    emit(
      state.copyWith(
        status: TasksStatus.actionLoading,
        actingTaskId: event.taskId,
        lastAction: event.action,
      ),
    );

    final result = await updateTaskStatus(
      params: UpdateTaskStatusParams(
        taskId: event.taskId,
        status: event.newStatus,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: TasksStatus.actionFailure,
            error: failure,
            lastAction: event.action,
            actingTaskId: event.taskId,
          ),
        );
      },
      (updatedTask) async {
        // Optimistically swap the updated task into the current list so the
        // card reflects the change instantly, and signal success (→ snackbar).
        final current = state.daily;
        if (current != null) {
          final newTasks = current.tasks
              .map((t) => t.id == updatedTask.id ? updatedTask : t)
              .toList();
          emit(
            state.copyWith(
              status: TasksStatus.actionSuccess,
              daily: DailyTasks(stats: current.stats, tasks: newTasks),
              lastAction: event.action,
              actingTaskId: event.taskId,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: TasksStatus.actionSuccess,
              lastAction: event.action,
              actingTaskId: event.taskId,
            ),
          );
        }

        // Refresh stats/list authoritatively (no loading flash) so the header
        // counters stay in sync with the source of truth.
        final refreshed = await getDailyTasks();
        refreshed.fold(
          (_) {},
          (daily) =>
              emit(state.copyWith(status: TasksStatus.loaded, daily: daily)),
        );
      },
    );
  }
}
