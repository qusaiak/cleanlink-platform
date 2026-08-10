import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';
import 'worker_availability_ui.dart';

/// "Current Status" card.
///
/// The worker may switch manually ONLY between Available and Off, so the card
/// is a two-segment toggle — `busy` is never offered. When the worker is
/// (derived) busy, the toggle is replaced by a read-only Busy row with a lock.
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

  /// The only two statuses the worker can pick manually.
  static const _options = [
    WorkerAvailability.available,
    WorkerAvailability.off,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final isBusy = selected == WorkerAvailability.busy;

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
          if (isBusy)
            _busyReadOnly(context, theme)
          else
            Row(
              children: [
                for (final option in _options) ...[
                  Expanded(child: _segment(context, theme, option)),
                  if (option != _options.last) SizedBox(width: 10.w),
                ],
              ],
            ),
        ],
      ),
    );
  }

  /// One side of the Available/Offline toggle.
  Widget _segment(
    BuildContext context,
    ColorScheme theme,
    WorkerAvailability availability,
  ) {
    final ui = WorkerAvailabilityUi.of(context, availability);
    final isSelected = availability == selected;
    final isUpdating = availability == updatingTo;

    return GestureDetector(
      // While a change is saving, the whole toggle ignores taps.
      onTap: updatingTo != null ? null : () => onChanged(availability),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? ui.color.withValues(alpha: 0.08) : theme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                isSelected ? ui.color : theme.onSurface.withValues(alpha: 0.1),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUpdating)
              SizedBox(
                width: 14.r,
                height: 14.r,
                child: spinKitApp(ui.color),
              )
            else
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? ui.color
                      : theme.onSurfaceVariant.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                ui.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.textStyle14.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shown while the system holds the worker busy: a locked, non-interactive
  /// Busy row — no manual change is possible until the task is released.
  Widget _busyReadOnly(BuildContext context, ColorScheme theme) {
    final ui = WorkerAvailabilityUi.of(context, WorkerAvailability.busy);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ui.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ui.color, width: 1.6),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(color: ui.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              ui.label,
              style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Icon(Icons.lock_rounded, size: 18.r, color: ui.color),
        ],
      ),
    );
  }
}
