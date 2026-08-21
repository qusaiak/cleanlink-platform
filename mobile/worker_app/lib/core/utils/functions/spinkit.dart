import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget spinKitApp(Color color) {
  return SizedBox(
    width: 30.r,
    height: 30.r,
    child: CircularProgressIndicator.adaptive(
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(color),
      backgroundColor: color.withValues(alpha: 0.15),
    ),
  );
}
