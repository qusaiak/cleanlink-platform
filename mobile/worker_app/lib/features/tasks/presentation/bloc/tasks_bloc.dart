import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../services/notification_service.dart';
import '../../domain/entities/daily_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/today_task_summary.dart';
import '../../domain/usecases/get_daily_tasks_usecase.dart';
import '../../domain/usecases/get_today_task_summary_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';
import '../../domain/usecases/watch_daily_tasks_usecase.dart';
import '../utils/tasks_refresh_signal.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetDailyTasksUseCase getDailyTasks;
  final GetTodayTaskSummaryUseCase getTodayTaskSummary;
  final UpdateTaskStatusUseCase updateTaskStatus;
  final WatchDailyTasksUseCase watchDailyTasks;

  StreamSubscription<DailyTasks>? _dailySub;

  StreamSubscription<void>? _pushSub;

  StreamSubscription<void>? _refreshSub;

  TasksBloc({
    required this.getDailyTasks,
    required this.getTodayTaskSummary,
    required this.updateTaskStatus,
    required this.watchDailyTasks,
  }) : super(const TasksState()) {
    on<LoadDailyTasks>(_onLoad);
    on<LoadTodayTaskSummary>(_onLoadSummary);
    on<FilterTasksByStatus>(_onFilter);
    on<ChangeTaskStatus>(_onChangeStatus);
    on<_DailyTasksSynced>(_onSynced);

    _dailySub = watchDailyTasks().listen((daily) {
      if (!isClosed) add(_DailyTasksSynced(daily));
    });

    _pushSub = NotificationService.instance.onPushReceived.listen((_) {
      if (!isClosed) add(const LoadDailyTasks());
      if (!isClosed) add(const LoadTodayTaskSummary());
    });
    _refreshSub = TasksRefreshSignal.instance.stream.listen((_) {
      if (!isClosed) add(const LoadDailyTasks());
      if (!isClosed) add(const LoadTodayTaskSummary());
    });

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
    if (state.status == TasksStatus.loading) return;

    emit(state.copyWith(status: TasksStatus.loading));

    final result = await getDailyTasks();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: TasksStatus.error, error: failure)),
      (_) {},
    );
  }

  Future<void> _onLoadSummary(
    LoadTodayTaskSummary event,
    Emitter<TasksState> emit,
  ) async {
    if (state.summaryStatus == SummaryStatus.loading) return;
    emit(state.copyWith(summaryStatus: SummaryStatus.loading));
    final result = await getTodayTaskSummary();
    result.fold(
      (failure) => emit(
        state.copyWith(
          summaryStatus: SummaryStatus.error,
          summaryError: failure,
        ),
      ),
      (summary) => emit(
        state.copyWith(
          summaryStatus: SummaryStatus.loaded,
          summary: summary,
          clearSummaryError: true,
        ),
      ),
    );
  }

  void _onFilter(FilterTasksByStatus event, Emitter<TasksState> emit) {
    emit(state.copyWith(status: TasksStatus.loaded, filter: event.status));
  }

  Future<void> _onChangeStatus(
    ChangeTaskStatus event,
    Emitter<TasksState> emit,
  ) async {
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
      (failure) => emit(
        state.copyWith(
          status: TasksStatus.actionFailure,
          error: failure,
          lastAction: event.action,
          actingTaskId: event.taskId,
        ),
      ),

      (_) {
        emit(
          state.copyWith(
            status: TasksStatus.actionSuccess,
            lastAction: event.action,
            actingTaskId: event.taskId,
          ),
        );
        add(const LoadDailyTasks());
        add(const LoadTodayTaskSummary());
      },
    );
  }
}
