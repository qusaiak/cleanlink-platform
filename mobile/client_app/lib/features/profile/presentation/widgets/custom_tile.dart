import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';

class CustomTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CustomTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColor.primaryColor),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Styles.textStyle12),
                  if (subtitle != null)
                    Text(subtitle!, style: Styles.textStyle11),
                ],
              ),
            ),

            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColor.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
