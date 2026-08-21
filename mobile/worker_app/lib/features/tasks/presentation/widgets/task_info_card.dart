import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';
import 'task_status_badge.dart';

class TaskInfoCard extends StatelessWidget {
  const TaskInfoCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  Icons.cleaning_services_outlined,
                  color: colors.primary,
                  size: 23.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle18.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l.task_request_number(task.requestNumber),
                      style: Styles.textStyle11.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              TaskStatusBadge(status: task.status),
            ],
          ),
          if (task.customerName.isNotEmpty) ...[
            SizedBox(height: 14.h),
            _InlineInfo(
              icon: Icons.person_outline_rounded,
              text: task.customerName,
            ),
          ],
          Divider(height: 28.h, color: colors.outlineVariant),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: Icons.schedule_rounded,
                  label: l.task_time_label,
                  value: formatTaskTime(task.scheduledAt),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _Metric(
                  icon: Icons.calendar_today_outlined,
                  label: l.task_date_label,
                  value: formatTaskDate(task.scheduledAt, locale),
                ),
              ),
            ],
          ),
          if (task.durationLabel.isNotEmpty || task.price > 0) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                if (task.durationLabel.isNotEmpty)
                  Expanded(
                    child: _Metric(
                      icon: Icons.timelapse_rounded,
                      label: l.task_duration_label,
                      value: task.durationLabel,
                    ),
                  ),
                if (task.durationLabel.isNotEmpty && task.price > 0)
                  SizedBox(width: 12.w),
                if (task.price > 0)
                  Expanded(
                    child: _Metric(
                      icon: Icons.payments_outlined,
                      label: l.task_price_label,
                      value: formatTaskPrice(task.price, task.currency),
                    ),
                  ),
              ],
            ),
          ],
          if (task.packageName.isNotEmpty || task.includedItems.isNotEmpty) ...[
            Divider(height: 28.h, color: colors.outlineVariant),
            _SectionTitle(
              icon: Icons.inventory_2_outlined,
              title: l.task_package_label,
            ),
            if (task.packageName.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Text(
                task.packageName,
                style: Styles.textStyle16.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (task.includedItems.isNotEmpty) ...[
              SizedBox(height: 12.h),
              for (final item in task.includedItems)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColor.successColor,
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item,
                          style: Styles.textStyle12.copyWith(
                            color: colors.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
          if (task.details.isNotEmpty) ...[
            Divider(height: 28.h, color: colors.outlineVariant),
            _SectionTitle(
              icon: Icons.notes_rounded,
              title: l.task_details_section,
            ),
            SizedBox(height: 9.h),
            Text(
              task.details,
              style: Styles.textStyle12.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
          Divider(height: 28.h, color: colors.outlineVariant),
          _TeamLeader(task: task),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.primary, size: 16.r),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle11.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle14.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colors.onSurfaceVariant, size: 18.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle12.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 19.r),
        SizedBox(width: 8.w),
        Text(
          title,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TeamLeader extends StatelessWidget {
  const _TeamLeader({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final accent = task.isTeamLeader
        ? AppColor.successColor
        : colors.onSurfaceVariant;

    return Row(
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.groups_2_outlined, color: accent, size: 20.r),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.task_leader_section,
                style: Styles.textStyle12.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (task.leaderName.isNotEmpty)
                Text(
                  task.leaderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            task.isTeamLeader ? l.task_leader_yes : l.task_leader_no,
            style: Styles.textStyle11.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
