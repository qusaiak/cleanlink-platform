import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget spinKitApp(Color color, {double? size, double strokeWidth = 3}) {
  final indicatorSize = size ?? 30.r;
  return SizedBox(
    width: indicatorSize,
    height: indicatorSize,
    child: CircularProgressIndicator.adaptive(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(color),
      backgroundColor: color.withValues(alpha: 0.15),
    ),
  );
}
