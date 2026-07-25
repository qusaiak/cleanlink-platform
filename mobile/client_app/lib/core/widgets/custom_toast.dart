import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';
import '../../config/theme/styles.dart';
import '../../l10n/app_localizations.dart';

void showToast({required String text, required state}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 13.sp,
    );

enum ToastState { success, error, warning, info }

Color chooseToastColor(ToastState state) {
  switch (state) {
    case ToastState.success:
      return AppColor.success;
    case ToastState.error:
      return AppColor.error;
    case ToastState.warning:
      return AppColor.warning;
    case ToastState.info:
      return AppColor.info;
  }
}

class AppSnackBar {
  AppSnackBar._();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSuccess({
    BuildContext? context,
    required String title,
    required String message,
    IconData? icon,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.check_circle_outline,
      color: AppColor.success,
    );
  }

  static void showError({
    BuildContext? context,
    required String title,
    required String message,
    IconData? icon,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.error_outline,
      color: AppColor.error,
    );
  }

  static void showWarning({
    BuildContext? context,
    required String title,
    required String message,
    IconData? icon,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.warning_amber_rounded,
      color: AppColor.warning,
    );
  }

  static void showInfo({
    BuildContext? context,
    required String title,
    required String message,
    IconData? icon,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.info_outline,
      color: AppColor.info,
    );
  }

  static void showSessionExpired({BuildContext? context}) {
    final l = _localizations(context);
    showWarning(
      context: context,
      title: l?.session_expired_title ?? 'Session expired',
      message:
          l?.session_expired_message ??
          'Your session has expired. Please log in again to continue.',
      icon: Icons.lock_clock_outlined,
    );
  }

  static void _show({
    BuildContext? context,
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    final messenger = context != null
        ? ScaffoldMessenger.maybeOf(context)
        : scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          duration: const Duration(seconds: 4),
          content: _AppSnackBarContent(
            title: title,
            message: message,
            icon: icon,
            color: color,
          ),
        ),
      );
  }

  static AppLocalizations? _localizations(BuildContext? context) {
    final currentContext = context ?? scaffoldMessengerKey.currentContext;
    if (currentContext == null) return null;
    return AppLocalizations.of(currentContext);
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Styles.textStyle14.copyWith(
                    color: theme.onSurface,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  message,
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurface.withValues(alpha: 0.68),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
