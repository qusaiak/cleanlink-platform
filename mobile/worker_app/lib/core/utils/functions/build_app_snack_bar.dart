import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/colors.dart';
import '../../../config/theme/styles.dart';

enum SnackBarType { success, error }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.success,
}) {
  final color = type == SnackBarType.success
      ? AppColor.successColor
      : AppColor.errorLight;
  final icon = type == SnackBarType.success
      ? Icons.check_circle_rounded
      : Icons.error_rounded;

  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      elevation: 2,
      margin: EdgeInsets.all(16.w),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: Styles.textStyle14.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
