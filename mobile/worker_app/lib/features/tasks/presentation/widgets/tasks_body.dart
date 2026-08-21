import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/network_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../profile/domain/entities/worker_profile.dart';
import '../../../profile/presentation/bloc/worker_profile_bloc.dart';
import '../../../profile/presentation/widgets/worker_availability_ui.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../utils/open_task.dart';
import '../utils/task_formatting.dart';
import 'task_status_ui.dart';
import 'worker_task_card.dart';

class TasksBody extends StatelessWidget {
  const TasksBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<TasksBloc, TasksState>(
      listenWhen: (previous, current) =>
          current.status == TasksStatus.actionSuccess ||
          current.status == TasksStatus.actionFailure,
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
        if (state.status == TasksStatus.loading && state.daily == null) {
          return Center(child: spinKitApp(colors.primary));
        }

        if (state.status == TasksStatus.error && state.daily == null) {
          return _ErrorView(
            message: state.error?.message ?? l.tasks_load_failed,
            onRetry: () =>
                context.read<TasksBloc>().add(const LoadDailyTasks()),
          );
        }

        return RefreshIndicator.adaptive(
          color: colors.primary,
          onRefresh: () async {
            final bloc = context.read<TasksBloc>();
            bloc
              ..add(const LoadDailyTasks())
              ..add(const LoadTodayTaskSummary());
            await bloc.stream.firstWhere(
              (next) =>
                  next.status != TasksStatus.loading &&
                  next.summaryStatus != SummaryStatus.loading,
            );
          },
          child: _DashboardContent(state: state),
        );
      },
    );
  }

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
      case TaskActionType.updateStatus:
      case null:
        return l.task_completed_message;
    }
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final TasksState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tasks = state.visibleTasks;
    final refreshing = state.status == TasksStatus.loading;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              if (refreshing)
                const LinearProgressIndicator(minHeight: 2)
              else
                SizedBox(height: 2.h),
              const _WorkerHomeHeader(),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _SummarySection(state: state),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.tasks_list_title,
                        style: Styles.textStyle18.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (state.filter != null)
                      Text(
                        TaskStatusUi.of(context, state.filter!).label,
                        style: Styles.textStyle12.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _StatusFilters(selected: state.filter),
              SizedBox(height: 18.h),
            ],
          ),
        ),
        if (tasks.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _EmptyView(l: l))
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return WorkerTaskCard(
                  task: task,
                  isActing:
                      state.status == TasksStatus.actionLoading &&
                      state.actingTaskId == task.id,
                  onTap: () async {
                    final updated = await context.push<Task>(
                      AppRouter.kTaskDetails,
                      extra: task,
                    );
                    if (updated != null && context.mounted) {
                      context.read<TasksBloc>()
                        ..add(const LoadDailyTasks())
                        ..add(const LoadTodayTaskSummary());
                    }
                  },
                  onAdvance: () => _advance(context, task),
                  onNavigate: () => _openMaps(task),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _advance(BuildContext context, Task task) async {
    if (task.id.isEmpty) {
      showAppSnackBar(
        context,
        message: AppLocalizations.of(context)!.task_open_failed,
        type: SnackBarType.error,
      );
      return;
    }
    final next = task.status.next;
    if (next == null) return;
    if (next == TaskStatus.completed) {
      await openTaskById(context, task.id, refreshTasksOnReturn: false);
      return;
    }
    if (!context.mounted) return;
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

  Future<void> _openMaps(Task task) async {
    final destination = task.latitude != null && task.longitude != null
        ? '${task.latitude},${task.longitude}'
        : Uri.encodeComponent(task.location);
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destination',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({required this.pending, required this.done});

  final int pending;
  final int done;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: colors.primary,
                size: 20.r,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.tasks_title,
                    style: Styles.textStyle14.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    formatTaskDate(DateTime.now(), locale),
                    style: Styles.textStyle11.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: _HeroMetric(
                icon: Icons.pending_actions_outlined,
                value: '$pending',
                label: l.tasks_pending_today,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _HeroMetric(
                icon: Icons.task_alt_rounded,
                value: '$done',
                label: l.tasks_completed_label,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.state});

  final TasksState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final summary = state.summary;
    if (summary != null) {
      return _DashboardHero(pending: summary.pending, done: summary.done);
    }
    if (state.summaryStatus == SummaryStatus.error) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, color: colors.onErrorContainer),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                l.tasks_load_failed,
                style: Styles.textStyle12.copyWith(
                  color: colors.onErrorContainer,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  context.read<TasksBloc>().add(const LoadTodayTaskSummary()),
              child: Text(l.retry),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 126.h,
      child: Center(child: spinKitApp(colors.primary)),
    );
  }
}

class _WorkerHomeHeader extends StatelessWidget {
  const _WorkerHomeHeader();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return BlocBuilder<WorkerProfileBloc, WorkerProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        final availability =
            state.effectiveAvailability ??
            profile?.availability ??
            WorkerAvailability.off;
        final availabilityUi = WorkerAvailabilityUi.of(context, availability);

        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
          child: Row(
            children: [
              InkWell(
                onTap: () => _openProfile(context),
                borderRadius: BorderRadius.circular(40.r),
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary,
                  ),
                  child: NetworkAvatar(
                    avatarUrl: profile?.avatarUrl ?? '',
                    radius: 25.r,
                    backgroundColor: colors.primaryContainer,
                    iconColor: colors.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: InkWell(
                  onTap: () => _openProfile(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.greeting_hello,
                        style: Styles.textStyle11.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        profile?.name ?? l.my_profile,
                        style: Styles.textStyle16.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Container(
                            width: 7.r,
                            height: 7.r,
                            decoration: BoxDecoration(
                              color: availabilityUi.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Flexible(
                            child: Text(
                              availabilityUi.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.textStyle11.copyWith(
                                color: availabilityUi.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              const _HomeNotificationsButton(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openProfile(BuildContext context) async {
    await context.push(AppRouter.kProfile);
    if (context.mounted) {
      context.read<WorkerProfileBloc>().add(const LoadWorkerProfile());
    }
  }
}

class _HomeNotificationsButton extends StatelessWidget {
  const _HomeNotificationsButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final unread = context.select<NotificationsBloc, int>(
      (bloc) => bloc.state.unreadCount,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: colors.onSurface.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              await context.push(AppRouter.kNotifications);
              if (context.mounted) {
                context.read<NotificationsBloc>().add(
                  const LoadNotifications(silent: true),
                );
              }
            },
            icon: Icon(
              Icons.notifications_none_outlined,
              color: colors.primary,
              size: 24.r,
            ),
          ),
        ),
        if (unread > 0)
          PositionedDirectional(
            end: -2.w,
            top: -2.h,
            child: Container(
              constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: colors.error,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colors.surface, width: 1.2),
              ),
              alignment: Alignment.center,
              child: Text(
                unread > 99 ? '99+' : '$unread',
                style: Styles.textStyle8.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(minHeight: 122.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(icon, color: colors.primary, size: 20.r),
              ),
              const Spacer(),
              Text(
                value,
                style: Styles.textStyle22.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle12.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({required this.selected});

  final TaskStatus? selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final entries = <MapEntry<TaskStatus?, String>>[
      MapEntry(null, l.filter_all),
      for (final status in TaskStatus.values)
        MapEntry(status, TaskStatusUi.of(context, status).label),
    ];

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: entries.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final active = entry.key == selected;
          final accent = entry.key == null
              ? colors.primary
              : TaskStatusUi.of(context, entry.key!).color;
          return ChoiceChip(
            selected: active,
            showCheckmark: false,
            label: Text(entry.value),
            labelStyle: Styles.textStyle12.copyWith(
              color: active ? colors.onPrimary : colors.onSurfaceVariant,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
            backgroundColor: colors.surface,
            selectedColor: accent,
            side: BorderSide(
              color: active
                  ? accent
                  : colors.outlineVariant.withValues(alpha: 0.7),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            onSelected: (_) =>
                context.read<TasksBloc>().add(FilterTasksByStatus(entry.key)),
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 64.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.r,
              height: 76.r,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_alt_rounded,
                size: 34.r,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              l.tasks_empty_title,
              style: Styles.textStyle18.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 7.h),
            Text(
              l.tasks_empty_subtitle,
              textAlign: TextAlign.center,
              style: Styles.textStyle12.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 58.r, color: colors.error),
            SizedBox(height: 18.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Styles.textStyle14.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 22.h),
            CustomElevatedButton(
              text: l.retry,
              width: 160.w,
              height: 48.h,
              onPressed: onRetry,
              buttonTextStyle: Styles.textStyle14.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
