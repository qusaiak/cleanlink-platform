import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../bloc/notifications_bloc.dart';

class NotificationBell extends StatelessWidget {
  final VoidCallback onTap;

  const NotificationBell({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final unread = context.select<NotificationsBloc, int>(
      (b) => b.state.unreadCount,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: AppColor.primarySoft,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.notifications_rounded, color: theme.primary),
            onPressed: onTap,
          ),
        ),
        if (unread > 0)
          PositionedDirectional(
            end: -2,
            top: -2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              constraints: BoxConstraints(minWidth: 18.w),
              decoration: BoxDecoration(
                color: theme.error,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: theme.surface, width: 1.5),
              ),
              child: Text(
                unread > 99 ? '99+' : '$unread',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: theme.onError,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
