import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../services/notification_service.dart';
import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_daily_tasks_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';
import '../../domain/usecases/watch_daily_tasks_usecase.dart';
import '../utils/tasks_refresh_signal.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

/// Drives the daily-tasks screen: loads the list/stats, applies status
/// filters, and performs worker actions (start / pause / complete / …) via
/// the domain use cases.
///
/// The task list is NOT held here as an independent copy: it is streamed from
/// the repository (the single source of truth). Any status change — from this
/// screen, the detail screen, or a notification — writes through the repository
/// and re-emits, so the list rebuilds on its own.
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetDailyTasksUseCase getDailyTasks;
  final UpdateTaskStatusUseCase updateTaskStatus;
  final WatchDailyTasksUseCase watchDailyTasks;

  StreamSubscription<DailyTasks>? _dailySub;

  /// Fires when a foreground push arrives (a task assigned while the app is
  /// open) — reload so the new task shows without a tap or manual refresh.
  StreamSubscription<void>? _pushSub;

  /// Fires when a notification tap (in-app / background / cold start) routes
  /// through `openTaskById` — the centralised refresh path.
  StreamSubscription<void>? _refreshSub;

  TasksBloc({
    required this.getDailyTasks,
    required this.updateTaskStatus,
    required this.watchDailyTasks,
  }) : super(const TasksState()) {
    on<LoadDailyTasks>(_onLoad);
    on<FilterTasksByStatus>(_onFilter);
    on<ChangeTaskStatus>(_onChangeStatus);
    on<_DailyTasksSynced>(_onSynced);

    // Rebuild whenever the shared source of truth changes (a load, or a status
    // update from any screen). This is the only path that sets `daily`.
    _dailySub = watchDailyTasks().listen((daily) {
      if (!isClosed) add(_DailyTasksSynced(daily));
    });

    // Auto-refresh triggers. Both funnel into the one reload path
    // (`LoadDailyTasks`), which keeps the current list on screen while it
    // refetches — see `_onLoad`.
    _pushSub = NotificationService.instance.onPushReceived.listen((_) {
      if (!isClosed) add(const LoadDailyTasks());
    });
    _refreshSub = TasksRefreshSignal.instance.stream.listen((_) {
      if (!isClosed) add(const LoadDailyTasks());
    });
    // Drain a refresh latched before this bloc existed (terminated cold start
    // launched from a notification), now that the list is initialising.
    TasksRefreshSignal.instance.consumePending();
  }

  @override
  Future<void> close() {
    _dailySub?.cancel();
    _pushSub?.cancel();
    _refreshSub?.cancel();
    return super.close();
  }

  void _onSynced(_DailyTasksSynced event, Emitter<TasksState> emit) {
    emit(state.copyWith(status: TasksStatus.loaded, daily: event.daily));
  }

  Future<void> _onLoad(LoadDailyTasks event, Emitter<TasksState> emit) async {
    // An auto-refresh (push / notification tap) can land while a load is
    // already running — e.g. a foreground push whose notification is then
    // tapped. Skip so one event never stacks duplicate requests.
    if (state.status == TasksStatus.loading) return;
    // Non-blocking: emit `loading` without dropping `daily`, so the list stays
    // on screen and the body shows a thin progress bar instead of the skeleton.
    emit(state.copyWith(status: TasksStatus.loading));
    // On success the repository emits on the stream (→ `_onSynced` sets the
    // list); only the failure branch needs handling here.
    final result = await getDailyTasks();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: TasksStatus.error, error: failure)),
      (_) {},
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
        currentStatus: event.currentStatus,
        newStatus: event.newStatus,
      ),
    );

    result.fold(
      // Failure → surface it (snackbar); the list is untouched, nothing to
      // revert since the swap only happens on the server's confirmation.
      (failure) => emit(
        state.copyWith(
          status: TasksStatus.actionFailure,
          error: failure,
          lastAction: event.action,
          actingTaskId: event.taskId,
        ),
      ),
      // Success → the repository already updated the shared cache and emitted,
      // so the card reflects the new status via `_onSynced`. We only signal
      // success here (→ snackbar).
      (_) => emit(
        state.copyWith(
          status: TasksStatus.actionSuccess,
          lastAction: event.action,
          actingTaskId: event.taskId,
        ),
      ),
    );
  }
}
