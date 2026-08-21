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
              IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(
                  Icons.menu_rounded,
                  color: theme.primary,
                  size: 24.r,
                ),
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(width: 2.w),

              Expanded(child: _ProfileButton()),
              SizedBox(width: 8.w),
              NotificationBell(
                onTap: () async {
                  await context.push(AppRouter.kNotifications);

                  if (context.mounted) {
                    context.read<NotificationsBloc>().add(
                      const LoadNotifications(silent: true),
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 4.h),

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

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: () async {
        await context.push(AppRouter.kProfile);

        if (context.mounted) {
          context.read<WorkerProfileBloc>().add(const LoadWorkerProfile());
        }
      },
      child: BlocBuilder<WorkerProfileBloc, WorkerProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          final name = profile?.name ?? l.my_profile;
          final avatarUrl = profile?.avatarUrl ?? '';

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
