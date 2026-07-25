import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/session/user_session.dart';
import 'package:client_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/helper_functions.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: sl<UserSession>(),
      builder: (context, child) {
        final session = sl<UserSession>();
        final displayName = session.fullname ?? 'Guest';
        final address = session.address;
        final image = session.image;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary,
                ),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundImage: resolveImage(image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.home_greeting(displayName),
                      style: Styles.textStyle16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (address != null && address.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: theme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            address,
                            style: Styles.textStyle12.copyWith(
                              color: theme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: theme.onSurface.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        color: theme.primary,
                      ),
                      onPressed: () {
                        GoRouter.of(context).push(AppRouter.kNotifications);
                      },
                    ),
                  ),
                  BlocBuilder<NotificationsBloc, NotificationsState>(
                    buildWhen: (previous, current) =>
                        previous.unreadCount != current.unreadCount,
                    builder: (context, state) {
                      final count = state.unreadCount;
                      if (count <= 0) return const SizedBox.shrink();
                      return Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          constraints: BoxConstraints(minWidth: 18.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: theme.surface, width: 1),
                          ),
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            textAlign: TextAlign.center,
                            style: Styles.textStyle8.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
