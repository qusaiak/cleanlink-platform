import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';
import 'task_status_badge.dart';

/// The main information card on the task-detail screen.
///
/// Shows exactly the private attributes of a worker-tasks-log entry: status,
/// order duration, total price, date, the selected package (name + details),
/// the service (name + rating), and whether the signed-in worker leads the
/// assigned workgroup. (Image + location are shown by [TaskLocationBanner]
/// above this card.)
class TaskInfoCard extends StatelessWidget {
  final Task task;

  const TaskInfoCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskStatusBadge(status: task.status),
              const Spacer(),
              if (task.price > 0) _priceTag(theme),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              if (task.durationLabel.isNotEmpty)
                Expanded(
                  child: _metric(
                    theme,
                    Icons.timelapse_rounded,
                    l.task_duration_label,
                    task.durationLabel,
                  ),
                ),
              Expanded(
                child: _metric(
                  theme,
                  Icons.calendar_today_rounded,
                  l.task_date_label,
                  formatTaskDate(task.scheduledAt, localeCode),
                ),
              ),
            ],
          ),
          if (task.title.isNotEmpty || task.serviceRating > 0) ...[
            Divider(
              height: 28.h,
              color: theme.onSurface.withValues(alpha: 0.08),
            ),
            _label(
              theme,
              Icons.cleaning_services_outlined,
              l.task_service_section,
            ),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.title.isNotEmpty)
                  Expanded(
                    child: Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (task.serviceRating > 0) ...[
                  SizedBox(width: 8.w),
                  _ratingChip(theme),
                ],
              ],
            ),
          ],
          if (task.packageName.isNotEmpty || task.includedItems.isNotEmpty) ...[
            Divider(
              height: 28.h,
              color: theme.onSurface.withValues(alpha: 0.08),
            ),
            _label(theme, Icons.local_offer_outlined, l.task_package_label),
            SizedBox(height: 8.h),
            if (task.packageName.isNotEmpty)
              Text(
                task.packageName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Styles.textStyle16.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (task.includedItems.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Text(
                l.task_package_details_label,
                style: Styles.textStyle12.copyWith(
                  color: theme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              ...task.includedItems.map((item) => _includedRow(theme, item)),
            ],
          ],
          Divider(height: 28.h, color: theme.onSurface.withValues(alpha: 0.08)),
          _leaderRow(theme, l),
        ],
      ),
    );
  }

  /// Emphasized pill showing the order's total price, e.g. "$75".
  Widget _priceTag(ColorScheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Text(
        formatTaskPrice(task.price, task.currency),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Styles.textStyle16.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Star-and-value chip showing the service's rating, e.g. "★ 4.2".
  Widget _ratingChip(ColorScheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.warningColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16.r, color: AppColor.warningColor),
          SizedBox(width: 4.w),
          Text(
            task.serviceRating.toStringAsFixed(1),
            style: Styles.textStyle12.copyWith(
              color: AppColor.warningColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// Whether the signed-in worker leads the assigned workgroup (boolean
  /// yes/no pill), plus the leader's full name + id underneath.
  Widget _leaderRow(ColorScheme theme, AppLocalizations l) {
    final isLeader = task.isTeamLeader;
    final color = isLeader ? AppColor.successColor : theme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shield_outlined, size: 18.r, color: theme.primary),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                l.task_leader_section,
                style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.xxl),
              ),
              child: Text(
                isLeader ? l.task_leader_yes : l.task_leader_no,
                style: Styles.textStyle12.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        if (task.leaderName.isNotEmpty) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 26.w),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    task.leaderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (task.leaderId.isNotEmpty) ...[
                  SizedBox(width: 6.w),
                  Text(
                    '#${task.leaderId}',
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// A single "what's included" line with a green check, mirroring the
  /// checklist the customer saw when choosing the package.
  Widget _includedRow(ColorScheme theme, String item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 18.r,
            color: AppColor.successColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              item,
              style: Styles.textStyle14.copyWith(
                color: theme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(ColorScheme theme, IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.r, color: theme.primary),
            SizedBox(width: 6.w),
            Text(
              label,
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _label(ColorScheme theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: theme.primary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
