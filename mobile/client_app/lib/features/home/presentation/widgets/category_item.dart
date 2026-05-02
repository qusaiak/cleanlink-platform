import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          borderRadius: BorderRadius.circular(16.r),
          color: theme.primary.withOpacity(0.08),
          border: Border.all(color: theme.primary.withOpacity(0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: theme.primary, size: 26),
            ),
            const SizedBox(height: 10),
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