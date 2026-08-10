
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColor.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Icon(icon, size: 16, color: AppColor.primaryColor),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Styles.textStyle12.copyWith(color: colorScheme.onSurface),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Styles.textStyle11.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),

            trailing ??
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
