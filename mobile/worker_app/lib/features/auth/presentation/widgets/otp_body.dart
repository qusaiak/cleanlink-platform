import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/otp_resend_timer.dart';
import 'otp_pin_field.dart';

class OtpBody extends StatelessWidget {
  const OtpBody({
    super.key,
    required this.state,
    required this.phoneLabel,
  });

  final AuthState state;
  final String phoneLabel;

  Future<void> _handleResend(BuildContext context) async {
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!context.mounted) return;
    // context.read<AuthBloc>().clearOtpAfterResend();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<AuthBloc>();
    final f = bloc.forms;

    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.h),
          const Center(child: AuthLogo()),
          SizedBox(height: 28.h),
          AuthHeader(
            title: l.auth_otp_title,
            subtitle: l.auth_otp_subtitle(phoneLabel),
          ),
          SizedBox(height: 36.h),
          Center(
            child: OtpPinField(
              controller: f.otpCode,
              focusNode: f.otpFocus,
              forceErrorState: false,
              onChanged: (_) {
                // if (state.otpHasError) bloc.clearOtpError();
              },
              // onCompleted: (_) => bloc.verifyOtpFromController(),
              onCompleted: (_){},
            ),
          ),
          SizedBox(height: 20.h),
          Center(child: OtpResendTimer(onResend: () => _handleResend(context))),
          SizedBox(height: 20.h),
          AppPrimaryButton(
            label: l.auth_otp_verify,
            // loading: state.isLoading,
            // onPressed: bloc.verifyOtpFromController,
            onPressed: (){},
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
