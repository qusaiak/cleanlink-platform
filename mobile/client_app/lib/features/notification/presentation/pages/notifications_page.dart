import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/widgets/app_empty_state.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    context.read<NotificationsBloc>().add(const GetNotificationsEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshNotifications() async {
    final bloc = context.read<NotificationsBloc>();
    bloc.add(const GetNotificationsEvent());
    await bloc.stream.firstWhere((state) => !state.isLoadingNotifications);
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
              previous.successMessage != current.successMessage,
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              AppSnackBar.showError(
                context: context,
                title: l10n.error,
                message: state.errorMessage!,
              );
              context.read<NotificationsBloc>().add(
                const ClearNotificationsMessageEvent(),
              );
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
            if (state.isLoadingNotifications && state.notifications.isEmpty) {
              return Center(child: spinKitApp(theme.primary));
            }

            return Stack(
              children: [
                RefreshIndicator(
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
                              final notification = state.notifications[index];
                              return NotificationCard(
                                notification: notification,
                                onTap: () {
                                  context.read<NotificationsBloc>().add(
                                    NotificationClickedEvent(notification),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (_, _) => SizedBox(height: 10.h),
                            itemCount: state.notifications.length,
                          ),
                  ),
                ),
                if (state.isLoadingNotifications &&
                    state.notifications.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      minHeight: 2.h,
                      color: theme.primary,
                      backgroundColor: theme.primary.withValues(alpha: 0.10),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
