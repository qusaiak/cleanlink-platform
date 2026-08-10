import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.iconData,
    required this.title,
    required this.onPressed,
  });

  final IconData iconData;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          color: theme.primary.withValues(alpha: 0.08),
          border: Border.all(color: theme.primary.withValues(alpha: 0.15)),
          boxShadow: AppShadow.card(Theme.of(context).brightness),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: theme.primary, size: 26.r),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Styles.textStyle14.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}