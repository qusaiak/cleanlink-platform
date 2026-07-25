import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';

/// Title and subtitle pair shown beneath the auth logo on every page.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.alignment = CrossAxisAlignment.center,
  });

  final String title;
  final String subtitle;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    final textAlign =
        alignment == CrossAxisAlignment.start ? TextAlign.start : TextAlign.center;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          textAlign: textAlign,
          style: Styles.textStyle24.copyWith(
            color: theme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: textAlign,
          maxLines: 2,
          style: Styles.textStyle14.copyWith(
            color: theme.onSurface.withValues(alpha: 0.65),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
