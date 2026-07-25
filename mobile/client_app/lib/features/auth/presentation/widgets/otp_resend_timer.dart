import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';

class OtpResendTimer extends StatelessWidget {
  const OtpResendTimer({
    super.key,
    required this.secondsRemaining,
    required this.isLoading,
    required this.onResend,
  });

  final int secondsRemaining;
  final bool isLoading;
  final VoidCallback onResend;

  String get _formattedDuration {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final canResend = secondsRemaining == 0 && !isLoading;
    final theme = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: canResend ? onResend : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primaryColor,
        disabledForegroundColor: theme.onSurface.withValues(alpha: 0.4),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      ),
      child: isLoading
          ? SizedBox(
              width: 16.r,
              height: 16.r,
              child: spinKitApp(theme.primary),
            )
          : Text(
              secondsRemaining > 0
                  ? l.auth_otp_resend_in(_formattedDuration)
                  : l.auth_otp_resend,
              style: Styles.textStyle14.copyWith(
                fontWeight: FontWeight.w600,
                color: canResend
                    ? AppColor.primaryColor
                    : theme.onSurface.withValues(alpha: 0.45),
              ),
            ),
    );
  }
}
