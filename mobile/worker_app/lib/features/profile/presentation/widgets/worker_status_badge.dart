import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../domain/entities/worker_profile.dart';
import 'worker_availability_ui.dart';

/// A compact availability pill (coloured dot + optional label) shown next to
/// the worker's name. It reflects the current [availability] and updates
/// whenever the status changes, since it's rebuilt from the profile bloc state.
class WorkerStatusBadge extends StatelessWidget {
  final WorkerAvailability availability;

  /// When false only the coloured dot is shown (tight spaces like the top bar).
  final bool showLabel;

  const WorkerStatusBadge({
    super.key,
    required this.availability,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final ui = WorkerAvailabilityUi.of(context, availability);

    final dot = Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(color: ui.color, shape: BoxShape.circle),
    );

    if (!showLabel) return dot;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ui.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot,
          SizedBox(width: 6.w),
          Text(
            ui.label,
            style: Styles.textStyle12.copyWith(
              color: ui.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
