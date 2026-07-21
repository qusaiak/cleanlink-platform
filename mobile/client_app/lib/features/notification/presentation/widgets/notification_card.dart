import 'package:client_app/config/theme/colors.dart';
import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/features/notification/domain/entities/app_notification_entity.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final AppNotificationEntity notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isUnread = !notification.isRead;
    final backgroundColor = isUnread
        ? theme.primary.withValues(alpha: 0.08)
        : theme.surface;
    final borderColor = isUnread
        ? theme.primary.withValues(alpha: 0.35)
        : theme.outlineVariant.withValues(alpha: 0.45);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: isUnread
                    ? theme.primary.withValues(alpha: 0.14)
                    : theme.onSurface.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: isUnread ? theme.primary : theme.onSurfaceVariant,
                size: 22.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 2,
                          style: Styles.textStyle14.copyWith(
                            color: theme.onSurface,
                            fontWeight: isUnread
                                ? FontWeight.w800
                                : FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (isUnread) ...[
                        SizedBox(width: 8.w),
                        Container(
                          width: 9.w,
                          height: 9.w,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.body,
                    maxLines: 3,
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurface.withValues(
                        alpha: isUnread ? 0.78 : 0.58,
                      ),
                      height: 1.35,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _formatCreatedAt(notification.createdAt),
                        style: Styles.textStyle11.copyWith(
                          color: theme.onSurfaceVariant,
                        ),
                      ),
                      _StatusChip(
                        label: isUnread ? l10n.unread : l10n.read,
                        isUnread: isUnread,
                      ),
                      if (notification.status != null &&
                          notification.status!.isNotEmpty)
                        _StatusChip(
                          label: notification.status!,
                          isUnread: false,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCreatedAt(DateTime? createdAt) {
    if (createdAt == null) return '';
    return DateFormat('MMM d, yyyy - HH:mm').format(createdAt.toLocal());
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isUnread;

  const _StatusChip({required this.label, required this.isUnread});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final color = isUnread ? theme.primary : theme.onSurfaceVariant;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: Styles.textStyle11.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
