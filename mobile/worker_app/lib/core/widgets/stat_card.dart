import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_decoration.dart';
import '../../config/theme/styles.dart';

/// A compact summary card (label + big value + icon) used in summary rows
/// such as the daily-tasks header and the worker profile stats.
///
/// [filled] renders the primary-coloured highlight variant (white text);
/// otherwise a soft tinted card. Colours derive from the theme's primary
/// (teal) — the design's blue is only a layout reference.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool filled;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final Color background = filled
        ? theme.primary
        : theme.primary.withValues(alpha: 0.08);
    final Color foreground = filled ? Colors.white : theme.primary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle12.copyWith(
                    color: foreground.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(icon, color: foreground, size: 20.r),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle22.copyWith(
              color: foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
