import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';

/// A subtle text-only link used for "Forgot password?", "Sign in" etc.
class AuthLinkButton extends StatelessWidget {
  const AuthLinkButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: Styles.textStyle14.copyWith(
          color: color ?? AppColor.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
