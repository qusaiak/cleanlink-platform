import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/presentation/utils/task_formatting.dart';
import '../../domain/entities/app_notification.dart';
import 'app_notification_ui.dart';

/// A single notification row: type icon, title + body, time, and an unread dot.
/// Unread tiles get a subtle tinted background. Tapping calls [onTap] (which
/// marks it read).
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final ui = AppNotificationUi.of(notification.type);
    final localeCode = Localizations.localeOf(context).languageCode;
    final unread = !notification.isRead;

    return Material(
      color: unread
          ? theme.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: ui.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(ui.icon, color: ui.color, size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Styles.textStyle14.copyWith(
                              fontWeight:
                                  unread ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsetsDirectional.only(start: 6.w),
                            decoration: BoxDecoration(
                              color: theme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.body,
                      style: Styles.textStyle12.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                      maxLines: 3,
                    ),
                    // Extra context for a client request (where / when).
                    if (notification.type ==
                            AppNotificationType.clientRequest &&
                        (notification.location != null ||
                            notification.scheduledAt != null)) ...[
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 4.h,
                        children: [
                          if (notification.location != null)
                            _meta(
                              theme,
                              Icons.location_on_rounded,
                              notification.location!,
                            ),
                          if (notification.scheduledAt != null)
                            _meta(
                              theme,
                              Icons.schedule_rounded,
                              '${formatTaskDate(notification.scheduledAt!, localeCode)} · '
                              '${formatTaskTime(notification.scheduledAt!)}',
                            ),
                        ],
                      ),
                    ],
                    SizedBox(height: 6.h),
                    Text(
                      '${l.notification_received} '
                      '${formatTaskDate(notification.createdAt, localeCode)} · '
                      '${formatTaskTime(notification.createdAt)}',
                      style: Styles.textStyle11.copyWith(
                        color: theme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(ColorScheme theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.r, color: theme.primary),
        SizedBox(width: 3.w),
        Text(
          text,
          style: Styles.textStyle11.copyWith(color: theme.primary),
        ),
      ],
    );
  }
}
