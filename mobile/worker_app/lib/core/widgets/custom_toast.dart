import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';

enum ToastState { success, error, warning }

void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 13.sp,
    );

Color chooseToastColor(ToastState state) {
  switch (state) {
    case ToastState.success:
      return AppColor.successColor;
    case ToastState.error:
      return AppColor.errorLight;
    case ToastState.warning:
      return AppColor.warningColor;
  }
}
