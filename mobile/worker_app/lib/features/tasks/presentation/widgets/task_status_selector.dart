import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import 'task_status_ui.dart';

/// Radio-style selector for the next task status on the detail screen.
///
/// Matches the design's three options (on the way / in progress / completed);
/// the selected option is highlighted with the primary (teal) accent.
class TaskStatusSelector extends StatelessWidget {
  final TaskStatus selected;
  final ValueChanged<TaskStatus> onChanged;

  const TaskStatusSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  // The worker-facing transitions offered on the detail screen.
  static const _options = [
    TaskStatus.onTheWay,
    TaskStatus.inProgress,
    TaskStatus.completed,
  ];

  static const _icons = {
    TaskStatus.onTheWay: Icons.directions_car_filled_outlined,
    TaskStatus.inProgress: Icons.more_horiz_rounded,
    TaskStatus.completed: Icons.check_circle_outline_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context, l.update_status_section),
        SizedBox(height: 12.h),
        ..._options.map((status) => _tile(context, status)),
      ],
    );
  }

  Widget _title(BuildContext context, String text) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.sync_rounded, size: 18.r, color: theme.primary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _tile(BuildContext context, TaskStatus status) {
    final theme = Theme.of(context).colorScheme;
    final ui = TaskStatusUi.of(context, status);
    final isSelected = status == selected;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: () => onChanged(status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primary.withValues(alpha: 0.08)
                : theme.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? theme.primary
                  : theme.onSurface.withValues(alpha: 0.1),
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(_icons[status], size: 20.r, color: ui.color),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  ui.label,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              _radio(theme, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radio(ColorScheme theme, bool isSelected) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? theme.primary : theme.onSurfaceVariant,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: theme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
