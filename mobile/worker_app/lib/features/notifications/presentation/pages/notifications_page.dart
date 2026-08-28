import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/notification_service.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_tile.dart';

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

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 240) {
      context.read<NotificationsBloc>().add(const LoadMoreNotifications());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          l.notifications_title,
          style: Styles.textStyle18.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
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
                return Center(child: spinKitApp(theme.primary));
              }
              if (state.status == NotificationsStatus.error) {
                return _error(context, l, theme);
              }
              return _empty(context, l, theme);
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<NotificationsBloc>().add(
                const LoadNotifications(silent: true),
              ),
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                itemCount: state.notifications.length + (state.hasMore ? 1 : 0),
                separatorBuilder: (_, __) => SizedBox(height: 6.h),
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    if (state.loadMoreError == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        context.read<NotificationsBloc>().add(
                          const LoadMoreNotifications(),
                        );
                      });
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: state.loadMoreError == null
                            ? spinKitApp(theme.primary, size: 24.r)
                            : TextButton(
                                onPressed: () => context
                                    .read<NotificationsBloc>()
                                    .add(const LoadMoreNotifications()),
                                child: Text(l.retry),
                              ),
                      ),
                    );
                  }
                  final n = state.notifications[index];
                  final orderId = n.requestId;
                  return NotificationTile(
                    notification: n,
                    isMarkingRead: state.markingReadIds.contains(n.id),
                    onMarkRead: () => context.read<NotificationsBloc>().add(
                      MarkNotificationRead(n.id),
                    ),

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
