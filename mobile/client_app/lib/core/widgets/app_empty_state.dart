import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/styles.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon,
    this.title,
    this.body,
    this.action,
    this.padding,
    this.iconSize,
    this.iconColor,
    this.textAlign = TextAlign.center,
    this.mainAxisSize = MainAxisSize.min,
  });

  final IconData? icon;
  final String? title;
  final String? body;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final Color? iconColor;
  final TextAlign textAlign;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? theme.primary;

    return Padding(
      padding: padding ?? EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize ?? 34.r,
                color: effectiveIconColor,
              ),
            ),
            SizedBox(height: 14.h),
          ],
          if (title != null && title!.isNotEmpty) ...[
            Text(
              title!,
              textAlign: textAlign,
              style: Styles.textStyle16.copyWith(
                color: theme.onSurface,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
          if (body != null && body!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              body!,
              textAlign: textAlign,
              style: Styles.textStyle12.copyWith(
                color: theme.onSurface.withValues(alpha: 0.62),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
          if (action != null) ...[SizedBox(height: 16.h), action!],
        ],
      ),
    );
  }
}
