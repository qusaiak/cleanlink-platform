import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/presentation/utils/open_task.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_tile.dart';

/// The worker's notification feed. Provides a feature-scoped
/// [NotificationsBloc] from `get_it` and loads on open.
///
/// Reached from the top-bar bell. Tapping a notification marks it read; the
/// app-bar action marks all read.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsBloc>(
      create: (_) => sl<NotificationsBloc>()..add(const LoadNotifications()),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.secondaryContainer,
      appBar: customAppBar(
        l.notifications_title,
        Icons.arrow_back_ios_new_rounded,
        [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            buildWhen: (p, c) => p.unreadCount != c.unreadCount,
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context
                    .read<NotificationsBloc>()
                    .add(const MarkAllNotificationsRead()),
                child: Text(
                  l.notifications_mark_all_read,
                  style: Styles.textStyle12.copyWith(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
        () => Navigator.of(context).maybePop(),
        theme.primary,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.notifications.isEmpty) {
              if (state.status == NotificationsStatus.loading) {
                return Center(child: spinKitApp(theme.primary));
              }
              if (state.status == NotificationsStatus.error) {
                return _error(context, l, theme);
              }
              return _empty(context, l, theme);
            }

            return RefreshIndicator(
              onRefresh: () async => context
                  .read<NotificationsBloc>()
                  .add(const LoadNotifications()),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => SizedBox(height: 6.h),
                itemBuilder: (context, index) {
                  final n = state.notifications[index];
                  return NotificationTile(
                    notification: n,
                    onTap: () {
                      // Mark read on tap…
                      if (!n.isRead) {
                        context
                            .read<NotificationsBloc>()
                            .add(MarkNotificationRead(n.id));
                      }
                      // …then open the task this notification refers to (its
                      // request id maps to the task). General notifications
                      // without a reference just mark read.
                      final ref = n.requestId;
                      if (ref != null && ref.isNotEmpty) {
                        openTaskById(context, ref);
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _empty(BuildContext context, AppLocalizations l, ColorScheme theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_rounded,
              size: 56.r,
              color: theme.primary.withValues(alpha: 0.4),
            ),
            SizedBox(height: 16.h),
            Text(
              l.notifications_empty_title,
              style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
            Text(
              l.notifications_empty_subtitle,
              textAlign: TextAlign.center,
              style:
                  Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _error(BuildContext context, AppLocalizations l, ColorScheme theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56.r, color: theme.error),
            SizedBox(height: 16.h),
            Text(
              l.notifications_load_failed,
              textAlign: TextAlign.center,
              style:
                  Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: l.retry,
              width: 160.w,
              height: 46.h,
              onPressed: () => context
                  .read<NotificationsBloc>()
                  .add(const LoadNotifications()),
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
