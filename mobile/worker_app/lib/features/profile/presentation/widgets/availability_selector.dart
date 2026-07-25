import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';
import 'worker_availability_ui.dart';

/// "Current Status" card: three selectable availability rows. The selected row
/// is highlighted with its status colour; the one being saved shows a spinner.
class AvailabilitySelector extends StatelessWidget {
  final WorkerAvailability selected;
  final WorkerAvailability? updatingTo;
  final ValueChanged<WorkerAvailability> onChanged;

  const AvailabilitySelector({
    super.key,
    required this.selected,
    required this.updatingTo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

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
          Text(
            l.current_status,
            style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          ...WorkerAvailability.values.map((a) => _row(context, theme, a)),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    ColorScheme theme,
    WorkerAvailability availability,
  ) {
    final ui = WorkerAvailabilityUi.of(context, availability);
    final isSelected = availability == selected;
    final isUpdating = availability == updatingTo;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: isUpdating ? null : () => onChanged(availability),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? ui.color.withValues(alpha: 0.08) : theme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? ui.color
                  : theme.onSurface.withValues(alpha: 0.1),
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ui.label,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isUpdating)
                SizedBox(
                  width: 16.r,
                  height: 16.r,
                  child: spinKitApp(ui.color),
                )
              else
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: ui.color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
