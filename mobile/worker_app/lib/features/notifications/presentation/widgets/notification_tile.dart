import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/presentation/utils/task_formatting.dart';
import '../../domain/entities/app_notification.dart';
import 'app_notification_ui.dart';

/// A single notification row: type icon, the full title + body (always
/// completely visible — nothing is collapsed behind a tap), time, and an
/// unread dot. Unread tiles get a subtle tinted background and a
/// "Mark as read" button that calls the mark-as-read endpoint via
/// [onMarkRead]; while the request runs ([isMarkingRead]) the button shows a
/// small spinner. Read notifications show no button.
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final bool isMarkingRead;
  final VoidCallback onMarkRead;

  /// Tapping the row opens the linked task and marks the notification read.
  /// Null for notifications that don't link anywhere.
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.isMarkingRead,
    required this.onMarkRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final ui = AppNotificationUi.of(notification.type);
    final localeCode = Localizations.localeOf(context).languageCode;
    final unread = !notification.isRead;

    // An unread task assignment is the feed's headline event — it gets an
    // accent outline on top of the usual unread tint so it stands out.
    final highlightAssignment =
        unread && notification.type == AppNotificationType.taskAssigned;

    return Material(
      color: unread
          ? theme.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      // A single [shape] carries both the rounding and the optional accent
      // outline — [Material] asserts if [shape] and [borderRadius] are set
      // together, so the corner radius lives inside the shape here.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: highlightAssignment
            ? BorderSide(
                color: theme.primary.withValues(alpha: 0.45),
                width: 1.4,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
                              fontWeight: unread
                                  ? FontWeight.bold
                                  : FontWeight.w600,
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
                    // The full body — never truncated or hidden behind a tap.
                    Text(
                      notification.body,
                      style: Styles.textStyle12.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
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
                    // "Mark as read" exists only while the notification is
                    // unread; once read (or already read) there's no button.
                    if (unread) ...[
                      SizedBox(height: 8.h),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: _markAsReadButton(theme, l),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _markAsReadButton(ColorScheme theme, AppLocalizations l) {
    return TextButton.icon(
      onPressed: isMarkingRead ? null : onMarkRead,
      style: TextButton.styleFrom(
        foregroundColor: theme.primary,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          side: BorderSide(color: theme.primary.withValues(alpha: 0.4)),
        ),
      ),
      icon: isMarkingRead
          ? SizedBox(
              width: 14.r,
              height: 14.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.primary,
              ),
            )
          : Icon(Icons.done_all_rounded, size: 16.r),
      label: Text(
        l.notification_mark_as_read,
        style: Styles.textStyle12.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _meta(ColorScheme theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.r, color: theme.primary),
        SizedBox(width: 3.w),
        Text(text, style: Styles.textStyle11.copyWith(color: theme.primary)),
      ],
    );
  }
}
