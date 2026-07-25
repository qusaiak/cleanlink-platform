import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/company_work_time_entity.dart';
import '../../domain/utils/company_working_hours.dart';

class WorkingHoursSection extends StatelessWidget {
  final CompanyEntity company;

  const WorkingHoursSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final isOpen = isCompanyCurrentlyOpen(company.workTimes);
    final today = getTodayCompanyWorkTime(company.workTimes);

    return Column(
      children: [
        RowTitle(iconData: Icons.access_time_rounded, title: l.working_hours),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: theme.outline.withValues(alpha: .08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isOpen ? l.open_label : l.closed_label,
                    style: Styles.textStyle12.copyWith(
                      color: isOpen ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      _formatWorkTime(context, today, l),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle12.copyWith(
                        color: theme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              for (final day in _orderedDays) ...[
                _WorkingHourItem(
                  day: _localizedDay(l, day),
                  time: _formatWorkTime(
                    context,
                    getCompanyWorkTimeForDay(company.workTimes, day),
                    l,
                  ),
                  isClosed: _isClosed(
                    getCompanyWorkTimeForDay(company.workTimes, day),
                  ),
                ),
                if (day != _orderedDays.last) SizedBox(height: 8.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

const _orderedDays = [1, 2, 3, 4, 5, 6, 0];

String _localizedDay(AppLocalizations l, int day) => switch (day) {
  0 => l.day_sunday,
  1 => l.day_monday,
  2 => l.day_tuesday,
  3 => l.day_wednesday,
  4 => l.day_thursday,
  5 => l.day_friday,
  6 => l.day_saturday,
  _ => '',
};

bool _isClosed(CompanyWorkTimeEntity? workTime) =>
    workTime == null ||
    workTime.isHoliday ||
    parseCompanyTime(workTime.openAt) == null ||
    parseCompanyTime(workTime.closeAt) == null;

String _formatWorkTime(
  BuildContext context,
  CompanyWorkTimeEntity? workTime,
  AppLocalizations l,
) {
  if (_isClosed(workTime)) return l.closed_label;
  final opening = parseCompanyTime(workTime!.openAt)!;
  final closing = parseCompanyTime(workTime.closeAt)!;
  final materialLocalizations = MaterialLocalizations.of(context);
  final use24Hour = MediaQuery.alwaysUse24HourFormatOf(context);
  final openingText = materialLocalizations.formatTimeOfDay(
    TimeOfDay(hour: opening.hour, minute: opening.minute),
    alwaysUse24HourFormat: use24Hour,
  );
  final closingText = materialLocalizations.formatTimeOfDay(
    TimeOfDay(hour: closing.hour, minute: closing.minute),
    alwaysUse24HourFormat: use24Hour,
  );
  return '$openingText – $closingText';
}

class _WorkingHourItem extends StatelessWidget {
  const _WorkingHourItem({
    required this.day,
    required this.time,
    required this.isClosed,
  });

  final String day;
  final String time;
  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: Styles.textStyle12.copyWith(
                color: theme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            time,
            textAlign: TextAlign.end,
            style: Styles.textStyle12.copyWith(
              fontWeight: FontWeight.w500,
              color: isClosed ? Colors.redAccent : theme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
