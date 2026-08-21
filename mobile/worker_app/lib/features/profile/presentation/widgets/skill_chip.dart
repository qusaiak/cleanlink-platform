import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';

class SkillChip extends StatelessWidget {
  final String label;

  final bool owned;

  final bool pending;

  final double maxWidth;

  final VoidCallback? onPressed;

  const SkillChip({
    super.key,
    required this.label,
    required this.owned,
    required this.pending,
    required this.maxWidth,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !pending;

    final foreground = owned ? theme.primary : theme.onSurfaceVariant;
    final background = owned
        ? theme.primary.withValues(alpha: 0.08)
        : Colors.transparent;
    final border = owned
        ? theme.primary.withValues(alpha: 0.18)
        : theme.onSurface.withValues(alpha: 0.12);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: enabled ? onPressed : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      softWrap: true,

                      style: Styles.textStyle12.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),

                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: pending
                          ? spinKitApp(foreground)
                          : Icon(
                              owned ? Icons.close_rounded : Icons.add_rounded,
                              size: 16.r,
                              color: foreground,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
