import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';

class OtpResendTimer extends StatefulWidget {
  const OtpResendTimer({super.key, required this.onResend, this.seconds = 30});

  final Future<void> Function() onResend;
  final int seconds;

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer> {
  Timer? _timer;
  int _remaining = 0;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _remaining = widget.seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
        if (mounted) setState(() => _remaining = 0);
      } else {
        if (mounted) setState(() => _remaining--);
      }
    });
  }

  Future<void> _handleResend() async {
    if (_sending || _remaining > 0) return;
    setState(() => _sending = true);
    try {
      await widget.onResend();
      _startCountdown();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final canResend = _remaining == 0 && !_sending;
    var theme = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: canResend ? _handleResend : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primaryColor,
        disabledForegroundColor: theme.onSurface.withValues(alpha: 0.4),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      ),
      child: _sending
          ? SizedBox(
              width: 16.r,
              height: 16.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.primaryColor,
              ),
            )
          : Text(
              _remaining > 0
                  ? l.auth_otp_resend_in(_remaining)
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
