import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/network_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
import '../../../profile/presentation/bloc/worker_profile_bloc.dart';
import '../../../profile/presentation/widgets/worker_availability_ui.dart';
import '../../../profile/presentation/widgets/worker_status_badge.dart';
import '../../../search/presentation/widgets/service_search_field.dart';

/// Top bar of the daily-tasks screen. Bundles the sidebar (menu) button, the
/// worker's account (profile button), the notifications bell with its live
/// unread badge, and the services search field.
///
/// The profile button and the sidebar header both read the same
/// [WorkerProfileBloc], so the account shown is identical in both places, and
/// both open the same [WorkerProfilePage].
///
/// Must be placed under [WorkerProfileBloc] + [NotificationsBloc] providers
/// (supplied at the tasks-screen level) and below the [Scaffold] (for the
/// drawer).
class TasksTopBar extends StatelessWidget {
  const TasksTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        children: [
          Row(
            children: [
              // Opens the sidebar (Profile / Settings).
              IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu_rounded, color: theme.primary, size: 24.r),
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(width: 2.w),
              // Profile button → opens the worker's profile (same account as
              // the sidebar). Avatar + name come from the WorkerProfileBloc.
              Expanded(child: _ProfileButton()),
              SizedBox(width: 8.w),
              NotificationBell(
                onTap: () async {
                  await context.push(AppRouter.kNotifications);
                  // Refresh the badge on return (a notification may have been
                  // read on the feed).
                  if (context.mounted) {
                    context
                        .read<NotificationsBloc>()
                        .add(const LoadNotifications(silent: true));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Services search — general / custom in one field. Submitting opens
          // the results screen with the chosen query.
          ServiceSearchField(
            onSearch: (query) =>
                context.push(AppRouter.kSearch, extra: query),
          ),
          SizedBox(height: 4.h),
          // Screen title.
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsets.only(top: 14.h, left: 4.w, right: 4.w),
              child: Text(
                l.tasks_title,
                style: Styles.textStyle20.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The worker's account chip in the top bar (avatar + name). Tapping opens the
/// profile screen.
class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: () async {
        await context.push(AppRouter.kProfile);
        // Reflect any availability/profile change made on the profile screen.
        if (context.mounted) {
          context.read<WorkerProfileBloc>().add(const LoadWorkerProfile());
        }
      },
      child: BlocBuilder<WorkerProfileBloc, WorkerProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          final name = profile?.name ?? l.my_profile;
          final avatarUrl = profile?.avatarUrl ?? '';
          // The avatar ring reflects the worker's availability: it changes
          // colour (green / amber / grey) as their status changes.
          final ringColor = profile != null
              ? WorkerAvailabilityUi.of(context, profile.availability).color
              : theme.primary;

          return Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.5.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: 1.5),
                ),
                child: NetworkAvatar(
                  avatarUrl: avatarUrl,
                  radius: 18.r,
                  backgroundColor: theme.primary.withValues(alpha: 0.1),
                  iconColor: theme.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.greeting_hello,
                      style: Styles.textStyle11.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle14.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Live availability dot beside the name.
                        if (profile != null) ...[
                          SizedBox(width: 6.w),
                          WorkerStatusBadge(
                            availability: profile.availability,
                            showLabel: false,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
