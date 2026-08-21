import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../domain/entities/worker_profile.dart';
import 'worker_availability_ui.dart';

class WorkerStatusBadge extends StatelessWidget {
  final WorkerAvailability availability;

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
