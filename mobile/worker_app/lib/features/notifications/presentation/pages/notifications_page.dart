import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/notification_service.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_tile.dart';

/// The worker's notification feed. Provides a feature-scoped
/// [NotificationsBloc] from `get_it` and loads on open.
///
/// Reached from the top-bar bell — the only place notifications are surfaced.
/// Each unread item carries its own "Mark as read" button.
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
        null,
        () => Navigator.of(context).maybePop(),
        theme.primary,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          // A failed mark-as-read surfaces as a snackbar; the list itself
          // stays as it is (the item simply remains unread).
          listenWhen: (prev, curr) =>
              curr.status == NotificationsStatus.markReadFailure,
          listener: (context, state) => showAppSnackBar(
            context,
            message: localizedFailureMessage(context, state.error),
            type: SnackBarType.error,
          ),
          builder: (context, state) {
            if (state.notifications.isEmpty) {
              if (state.status == NotificationsStatus.loading) {
                return _loadingSkeleton(context);
              }
              if (state.status == NotificationsStatus.error) {
                return _error(context, l, theme);
              }
              return _empty(context, l, theme);
            }

            return RefreshIndicator(
              // Silent: the RefreshIndicator is already the loading signal —
              // no need to swap the list for the skeleton.
              onRefresh: () async => context.read<NotificationsBloc>().add(
                const LoadNotifications(silent: true),
              ),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => SizedBox(height: 6.h),
                itemBuilder: (context, index) {
                  final n = state.notifications[index];
                  final orderId = n.requestId;
                  return NotificationTile(
                    notification: n,
                    isMarkingRead: state.markingReadIds.contains(n.id),
                    onMarkRead: () => context.read<NotificationsBloc>().add(
                      MarkNotificationRead(n.id),
                    ),
                    // Tapping marks it read and opens the linked task's detail,
                    // through the same entry point FCM taps use. Only task
                    // notifications (those carrying an order id) are tappable.
                    onTap: orderId == null || orderId.isEmpty
                        ? null
                        : () {
                            context.read<NotificationsBloc>().add(
                              MarkNotificationRead(n.id),
                            );
                            NotificationService.instance
                                .openTaskFromNotification(orderId);
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

  /// Shimmer skeleton shown while the feed is loading, shaped like a handful
  /// of [NotificationTile] rows (leading icon badge + title/body/timestamp
  /// lines) so the loading state doesn't jump visually once data arrives.
  Widget _loadingSkeleton(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 6.h),
      itemBuilder: (context, index) => _skeletonTile(index),
    );
  }

  Widget _skeletonTile(int index) {
    // Vary the body-line width a little per row so the skeleton doesn't look
    // like a perfectly uniform repeated block.
    final bodyWidths = [double.infinity, 220.w, 260.w];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerBox(width: 42.w, height: 42.w, radius: 21.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerBox(
                  width: double.infinity,
                  height: 14.h,
                  radius: AppRadius.xs,
                ),
                SizedBox(height: 8.h),
                AppShimmerBox(
                  width: bodyWidths[index % bodyWidths.length],
                  height: 12.h,
                  radius: AppRadius.xs,
                ),
                SizedBox(height: 6.h),
                AppShimmerBox(width: 110.w, height: 10.h, radius: AppRadius.xs),
              ],
            ),
          ),
        ],
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
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
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
              style: Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: l.retry,
              width: 160.w,
              height: 46.h,
              onPressed: () => context.read<NotificationsBloc>().add(
                const LoadNotifications(),
              ),
              buttonTextStyle: Styles.textStyle14.copyWith(
                color: theme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
