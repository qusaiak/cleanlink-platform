import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_decoration.dart';
import '../../config/theme/styles.dart';

class RatingBadge extends StatelessWidget {
  final double rating;

  const RatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(1),
            style: Styles.textStyle12.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
