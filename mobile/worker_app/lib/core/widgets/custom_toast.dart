import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


void showToast({
  required String text,
  required state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      //backgroundColor: chooseToastColor(state),
      //textColor: Colors.black87,
      fontSize: 13.sp,
    );

enum ToastState { success, error, warning }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.success:
      color = Colors.black;
      break;
    case ToastState.error:
      color = Colors.black;
      break;
    case ToastState.warning:
      color = Colors.black;
      break;
  }
  return color;
}