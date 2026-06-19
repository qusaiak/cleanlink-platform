import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';

/// The main information card on the task-detail screen: optional urgency badge,
/// title, time + date, the description, and the required-tools chips.
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
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.isUrgent) ...[
            _urgentBadge(l),
            SizedBox(height: 10.h),
          ],
          Text(
            task.title,
            style: Styles.textStyle18.copyWith(fontWeight: FontWeight.bold),
          ),
          if (task.companyName.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.business_rounded, size: 16.r, color: theme.primary),
                SizedBox(width: 6.w),
                Text(
                  task.companyName,
                  style: Styles.textStyle14.copyWith(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (task.packageName.isNotEmpty || task.price > 0) ...[
            SizedBox(height: 12.h),
            _packageBanner(theme, l),
          ],
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _metric(
                  theme,
                  Icons.access_time_rounded,
                  l.task_time_label,
                  formatTaskTime(task.scheduledAt),
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
          if (task.durationLabel.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _metric(
                    theme,
                    Icons.timelapse_rounded,
                    l.task_duration_label,
                    task.durationLabel,
                  ),
                ),
                if (task.packageName.isNotEmpty)
                  Expanded(
                    child: _metric(
                      theme,
                      Icons.local_offer_outlined,
                      l.task_package_label,
                      task.packageName,
                    ),
                  ),
              ],
            ),
          ],
          if (task.includedItems.isNotEmpty) ...[
            Divider(height: 28.h, color: theme.onSurface.withValues(alpha: 0.08)),
            _label(theme, Icons.checklist_rounded, l.task_included_section),
            SizedBox(height: 10.h),
            ...task.includedItems.map((item) => _includedRow(theme, item)),
          ],
          if (task.details.isNotEmpty) ...[
            Divider(height: 28.h, color: theme.onSurface.withValues(alpha: 0.08)),
            _label(theme, Icons.description_outlined, l.task_details_section),
            SizedBox(height: 8.h),
            Text(
              task.details,
              style: Styles.textStyle12.copyWith(
                color: theme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ],
          if (task.requiredTools.isNotEmpty) ...[
            SizedBox(height: 18.h),
            _label(theme, Icons.build_outlined, l.task_required_tools),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: task.requiredTools.map((t) => _toolChip(theme, t)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _urgentBadge(AppLocalizations l) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColor.warningColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high_rounded,
              size: 14.r, color: AppColor.warningColor),
          SizedBox(width: 4.w),
          Text(
            l.task_urgent_badge,
            style: Styles.textStyle11.copyWith(
              color: AppColor.warningColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// Highlights the package the customer selected and its price, e.g.
  /// "Studio" on the start side and "$75" as an emphasized pill.
  Widget _packageBanner(ColorScheme theme, AppLocalizations l) {
    final hasPrice = task.price > 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.task_package_label,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  task.packageName.isNotEmpty ? task.packageName : '—',
                  style: Styles.textStyle16.copyWith(
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (hasPrice)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                formatTaskPrice(task.price, task.currency),
                style: Styles.textStyle16.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
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
          Icon(Icons.check_circle_rounded,
              size: 18.r, color: AppColor.successColor),
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

  Widget _toolChip(ColorScheme theme, String tool) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        tool,
        style: Styles.textStyle12.copyWith(
          color: theme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
