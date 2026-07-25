import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import 'tasks_filter.dart';
import 'tasks_top_bar.dart';
import 'worker_task_card.dart';

/// Body of the daily-tasks screen. Listens to [TasksBloc] to:
///  - show success/failure snackbars after worker actions, and
///  - render loading / error / content states for the list.
class TasksBody extends StatelessWidget {
  const TasksBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocConsumer<TasksBloc, TasksState>(
      // Only react to the transient action outcomes for snackbars.
      listenWhen: (prev, curr) =>
          curr.status == TasksStatus.actionSuccess ||
          curr.status == TasksStatus.actionFailure,
      listener: (context, state) {
        if (state.status == TasksStatus.actionSuccess) {
          showAppSnackBar(
            context,
            message: _successMessage(context, state),
            type: SnackBarType.success,
          );
        } else if (state.status == TasksStatus.actionFailure) {
          showAppSnackBar(
            context,
            message: state.error?.message ?? l.task_action_failed_message,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        // First load with nothing yet → full-screen spinner.
        if (state.status == TasksStatus.loading && state.daily == null) {
          return Center(child: spinKitApp(Theme.of(context).colorScheme.primary));
        }

        // Load failed and we have nothing to show → error + retry.
        if (state.status == TasksStatus.error && state.daily == null) {
          return _ErrorView(
            message: state.error?.message ?? l.tasks_load_failed,
            onRetry: () =>
                context.read<TasksBloc>().add(const LoadDailyTasks()),
          );
        }

        return RefreshIndicator(
          onRefresh: () async =>
              context.read<TasksBloc>().add(const LoadDailyTasks()),
          child: _content(context, state, l),
        );
      },
    );
  }

  Widget _content(BuildContext context, TasksState state, AppLocalizations l) {
    final stats = state.daily?.stats;
    final tasks = state.visibleTasks;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 8.h),
        const TasksTopBar(),
        SizedBox(height: 12.h),

        // Summary stat cards.
        if (stats != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: l.tasks_remaining_today,
                    value: '${stats.remainingToday}',
                    icon: Icons.pending_actions_rounded,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: StatCard(
                    label: l.tasks_completed_label,
                    value: '${stats.completed} / ${stats.total}',
                    icon: Icons.check_circle_rounded,
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 22.h),

        // Section header + filter.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TasksSectionHeader(
            activeFilter: state.filter,
            onFilterSelected: (status) =>
                context.read<TasksBloc>().add(FilterTasksByStatus(status)),
          ),
        ),
        SizedBox(height: 12.h),

        // The list (or an empty state).
        if (tasks.isEmpty)
          _EmptyView(l: l)
        else
          ...tasks.map(
            (task) => Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
              child: WorkerTaskCard(
                task: task,
                isActing: state.status == TasksStatus.actionLoading &&
                    state.actingTaskId == task.id,
                onTap: () async {
                  // Open the detail screen; refresh the list on return so any
                  // status/photo changes made there are reflected.
                  final bloc = context.read<TasksBloc>();
                  await context.push(AppRouter.kTaskDetails, extra: task);
                  bloc.add(const LoadDailyTasks());
                },
                onStart: () => context.read<TasksBloc>().add(
                  ChangeTaskStatus(
                    taskId: task.id,
                    newStatus: TaskStatus.inProgress,
                    action: TaskActionType.start,
                  ),
                ),
                onPause: () => context.read<TasksBloc>().add(
                  ChangeTaskStatus(
                    taskId: task.id,
                    newStatus: TaskStatus.paused,
                    action: TaskActionType.pause,
                  ),
                ),
                onComplete: () => context.read<TasksBloc>().add(
                  ChangeTaskStatus(
                    taskId: task.id,
                    newStatus: TaskStatus.completed,
                    action: TaskActionType.complete,
                  ),
                ),
                onNavigate: () => _openMaps(task.location),
              ),
            ),
          ),

        // Bottom breathing room so the FAB / nav bar don't overlap content.
        SizedBox(height: 90.h),
      ],
    );
  }

  /// Resolves the localized success message for the last performed action.
  String _successMessage(BuildContext context, TasksState state) {
    final l = AppLocalizations.of(context)!;
    switch (state.lastAction) {
      case TaskActionType.start:
        return l.task_started_message;
      case TaskActionType.pause:
        return l.task_paused_message;
      case TaskActionType.complete:
        return l.task_completed_message;
      case TaskActionType.accept:
        return l.task_accepted_message;
      case TaskActionType.cancel:
        return l.task_cancelled_message;
      case TaskActionType.updateStatus:
      case null:
        return l.task_completed_message;
    }
  }

  /// Opens the device maps app at the task location (uses url_launcher).
  Future<void> _openMaps(String location) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query='
      '${Uri.encodeComponent(location)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Empty-list placeholder.
class _EmptyView extends StatelessWidget {
  final AppLocalizations l;

  const _EmptyView({required this.l});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 56.r,
            color: theme.primary.withValues(alpha: 0.4),
          ),
          SizedBox(height: 16.h),
          Text(
            l.tasks_empty_title,
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.h),
          Text(
            l.tasks_empty_subtitle,
            textAlign: TextAlign.center,
            style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Full-screen error with a retry button (used when the first load fails).
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56.r, color: theme.error),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: l.retry,
              width: 160.w,
              height: 46.h,
              onPressed: onRetry,
              buttonTextStyle: Styles.textStyle14.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
