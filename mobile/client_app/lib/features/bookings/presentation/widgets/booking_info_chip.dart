import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';

class BookingInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const BookingInfoChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),

      decoration: BoxDecoration(
        color: AppColor.transparent,

        borderRadius: BorderRadius.circular(
          16.r,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 16.sp,
            color: theme.primary,
          ),

          SizedBox(
            width: 6.w,
          ),

          Flexible(
            child: Text(
              text,
              overflow:
              TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}