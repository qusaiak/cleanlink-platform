import 'dart:async';

import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/widgets/app_empty_state.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/core/widgets/pagination_footer.dart';
import 'package:client_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:client_app/features/notification/presentation/widgets/notification_card.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const double _loadMoreThreshold = 250;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<NotificationsBloc>().add(const GetNotificationsEvent());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<NotificationsBloc>().add(const GetMoreNotificationsEvent());
    }
  }

  Future<void> _refreshNotifications() {
    final completer = Completer<void>();
    context.read<NotificationsBloc>().add(
      GetNotificationsEvent(refresh: true, completer: completer),
    );
    return completer.future;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(
          l10n.notifications,
          style: Styles.textStyle18.copyWith(
            color: theme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage ||
              previous.successMessage != current.successMessage ||
              previous.loadMoreError != current.loadMoreError,
          listener: (context, state) {
            final message = state.loadMoreError ?? state.errorMessage;
            if (message != null && message.isNotEmpty) {
              AppSnackBar.showError(
                context: context,
                title: l10n.error,
                message: message,
              );
              if (state.errorMessage != null) {
                context.read<NotificationsBloc>().add(
                  const ClearNotificationsMessageEvent(),
                );
              }
            }
            if (state.successMessage == 'notification_open_failed') {
              AppSnackBar.showInfo(
                context: context,
                title: l10n.notifications,
                message: l10n.notification_open_failed,
              );
              context.read<NotificationsBloc>().add(
                const ClearNotificationsMessageEvent(),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoadingNotifications) {
              return Center(child: spinKitApp(theme.primary));
            }
            if (state.notificationsError != null &&
                state.notifications.isEmpty) {
              return _ErrorView(
                message: state.notificationsError!,
                onRetry: () => context.read<NotificationsBloc>().add(
                  const GetNotificationsEvent(),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: state.notifications.length > 4,
                child: state.notifications.isEmpty
                    ? ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 96.h),
                          AppEmptyState(
                            icon: Icons.notifications_none_rounded,
                            title: l10n.no_notifications,
                            body: l10n.no_notifications_message,
                          ),
                        ],
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                        itemBuilder: (context, index) {
                          if (index == state.notifications.length) {
                            return PaginationFooter(
                              isLoading: state.isLoadingMore,
                              errorMessage: state.loadMoreError == null
                                  ? null
                                  : l10n.could_not_load_more_notifications,
                              onRetry: () =>
                                  context.read<NotificationsBloc>().add(
                                    const GetMoreNotificationsEvent(
                                      retry: true,
                                    ),
                                  ),
                            );
                          }
                          final notification = state.notifications[index];
                          return NotificationCard(
                            notification: notification,
                            onTap: () => context.read<NotificationsBloc>().add(
                              NotificationClickedEvent(notification),
                            ),
                          );
                        },
                        separatorBuilder: (_, _) => SizedBox(height: 10.h),
                        itemCount: state.notifications.length + 1,
                      ),
              ),
            );
          },
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 42.sp),
            SizedBox(height: 10.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}
