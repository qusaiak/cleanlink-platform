import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'colors.dart';
import 'styles.dart';

abstract class AppRadius {
  const AppRadius();

  static double get xs => 8.r;
  static double get sm => 12.r;
  static double get md => 14.r;
  static double get lg => 16.r;
  static double get xl => 18.r;
  static double get xxl => 20.r;
  static double get pill => 999;

  static BorderRadius get chip => BorderRadius.circular(xs);
  static BorderRadius get input => BorderRadius.circular(md);
  static BorderRadius get button => BorderRadius.circular(md);
  static BorderRadius get card => BorderRadius.circular(xl);
  static BorderRadius get sheet =>
      BorderRadius.vertical(top: Radius.circular(xxl));
  static BorderRadius get dialog => BorderRadius.circular(xxl);
}

abstract class AppShadow {
  const AppShadow();

  static List<BoxShadow> card(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.28),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColor.primaryColorDarker.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static List<BoxShadow> floating(Brightness brightness) {
    return [
      BoxShadow(
        color: Colors.black.withValues(
          alpha: brightness == Brightness.dark ? 0.4 : 0.12,
        ),
        blurRadius: 28,
        offset: const Offset(0, 12),
      ),
    ];
  }
}

class AppDecoration {
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColor.primaryGradientColors,
  );

  static BoxDecoration softBadge(Color color, {double radius = 999}) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static PinTheme get defaultPinTheme => PinTheme(
    width: 56.w,
    height: 56.w,
    textStyle: Styles.textStyle18.copyWith(color: Colors.white),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.gray500),
      borderRadius: BorderRadius.circular(AppRadius.xxl),
    ),
  );

  static PinTheme get focusedPinTheme => PinTheme(
    width: 56.w,
    height: 56.w,
    textStyle: Styles.textStyle18.copyWith(color: AppColor.primaryColor),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.primaryLight, width: 1.5),
      borderRadius: BorderRadius.circular(AppRadius.xxl),
    ),
  );

  static PinTheme get submittedPinTheme => PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: Styles.textStyle18.copyWith(color: AppColor.primaryColor),
    decoration: BoxDecoration(
      color: AppColor.primarySoft,
      border: Border.all(color: AppColor.primaryLight),
      borderRadius: BorderRadius.circular(AppRadius.xxl),
    ),
  );
}
