import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../utils/open_task.dart';
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
            message: localizedFailureMessage(context, state.error),
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        // First load with nothing yet → shimmer skeleton list, shaped like
        // the real task cards so the transition into content is seamless.
        if (state.status == TasksStatus.loading && state.daily == null) {
          return const _TasksLoadingSkeleton();
        }

        // Load failed and we have nothing to show → error + retry.
        if (state.status == TasksStatus.error && state.daily == null) {
          return _ErrorView(
            message: state.error?.message ?? l.tasks_load_failed,
            onRetry: () =>
                context.read<TasksBloc>().add(const LoadDailyTasks()),
          );
        }

        // A background auto-refresh (push / notification) keeps the loaded
        // list on screen; a thin bar signals it non-blockingly.
        final refreshing =
            state.status == TasksStatus.loading && state.daily != null;

        return Column(
          children: [
            SizedBox(
              height: 2.h,
              child: refreshing ? const LinearProgressIndicator() : null,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async =>
                    context.read<TasksBloc>().add(const LoadDailyTasks()),
                child: _content(context, state, l),
              ),
            ),
          ],
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
                // Fetch the task's private detail (GET /api/tasks/{id}) and open
                // the detail screen. A status change there writes through the
                // repository (the single source of truth), so this card updates
                // on its own — no list reload needed (unlike a notification tap).
                onTap: () =>
                    openTaskById(context, task.id, refreshTasksOnReturn: false),
                onAdvance: () => _advance(context, task),
                onNavigate: () => _openMaps(task.location),
              ),
            ),
          ),

        // Bottom breathing room so the FAB / nav bar don't overlap content.
        SizedBox(height: 90.h),
      ],
    );
  }

  /// Advances [task] one step along the strict
  /// `pending → on_way → handling → done` sequence.
  ///
  /// The final step is special: before/after photos may only be uploaded with
  /// `done`, so instead of firing the request blindly the card opens the task
  /// detail screen, where the leader can attach them and confirm. Every other
  /// step is a plain status change fired from the list.
  Future<void> _advance(BuildContext context, Task task) async {
    final next = task.status.next;
    if (next == null) return;

    if (next == TaskStatus.completed) {
      // The `done` step needs before/after photos, so it's completed on the
      // detail screen; the repository propagates the change back to this list.
      await openTaskById(context, task.id, refreshTasksOnReturn: false);
      return;
    }

    context.read<TasksBloc>().add(
      ChangeTaskStatus(
        taskId: task.id,
        currentStatus: task.status,
        newStatus: next,
        action: next == TaskStatus.onTheWay
            ? TaskActionType.onWay
            : TaskActionType.start,
      ),
    );
  }

  /// Resolves the localized success message for the last performed action.
  String _successMessage(BuildContext context, TasksState state) {
    final l = AppLocalizations.of(context)!;
    switch (state.lastAction) {
      case TaskActionType.onWay:
        return l.task_on_way_message;
      case TaskActionType.start:
        return l.task_started_message;
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
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmering placeholder for the initial task-list load. Shaped to roughly
/// match [WorkerTaskCard] (leading thumb + name + status badge, a couple of
/// info lines, an action row) so the swap to real content doesn't jump.
class _TasksLoadingSkeleton extends StatelessWidget {
  const _TasksLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: const _SkeletonTaskCard(),
      ),
    );
  }
}

class _SkeletonTaskCard extends StatelessWidget {
  const _SkeletonTaskCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmerBox(width: 44.w, height: 44.w, radius: AppRadius.sm),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(width: 120.w, height: 14.h),
                    SizedBox(height: 8.h),
                    AppShimmerBox(width: 70.w, height: 10.h),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              AppShimmerBox(
                width: 64.w,
                height: 20.h,
                radius: AppRadius.pill,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppShimmerBox(width: 180.w, height: 12.h),
          SizedBox(height: 8.h),
          AppShimmerBox(width: 140.w, height: 12.h),
          SizedBox(height: 8.h),
          AppShimmerBox(width: 110.w, height: 12.h),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppShimmerBox(
                  height: 48.h,
                  radius: AppRadius.sm,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppShimmerBox(
                  height: 48.h,
                  radius: AppRadius.sm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
