import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/otp_resend_timer.dart';
import 'otp_pin_field.dart';

class OtpBody extends StatelessWidget {
  const OtpBody({super.key, required this.state, required this.email});

  final AuthState state;
  final String email;

  void _handleResend(BuildContext context) {
    HapticFeedback.lightImpact();
    context.read<AuthBloc>().add(const RequestResendVerificationCode());
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
            subtitle: l.auth_otp_subtitle(email),
          ),
          SizedBox(height: 36.h),
          Center(
            child: OtpPinField(
              controller: f.otpCode,
              focusNode: f.otpFocus,
              forceErrorState:
                  state.status == AuthStatus.errorVerifyAccount &&
                  state.error != null,
              onChanged: (code) => bloc.add(OtpChanged(code)),
              onCompleted: (_) {},
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: OtpResendTimer(
              secondsRemaining: state.resendSecondsRemaining,
              isLoading: state.isRequestResendVerificationCodeLoading == true,
              onResend: () => _handleResend(context),
            ),
          ),
          SizedBox(height: 20.h),
          AppPrimaryButton(
            label: l.auth_otp_verify,
            loading: state.isVerifyAccountLoading == true,
            onPressed: state.isVerifyAccountLoading == true
                ? null
                : () => bloc.add(VerifyAccount(f.otpCode.text)),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
