import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/otp_body.dart';
import 'package:client_app/features/auth/presentation/utils/auth_error_localizer.dart';
import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/features/auth/domain/entities/pending_registration_data.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.pendingRegistration});

  final PendingRegistrationData pendingRegistration;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
    _authBloc.add(
      const OtpCountdownStarted(seconds: AuthBloc.otpResendCountdownSeconds),
    );
  }

  @override
  void dispose() {
    _authBloc.add(const OtpFlowCancelled());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final l = AppLocalizations.of(context)!;
        if (state.status == AuthStatus.successVerifyAccount) {
          AppSnackBar.showSuccess(
            context: context,
            title: l.success,
            message: state.successMessage ?? '',
          );
          context.go(AppRouter.kPersonalDetails);
        } else if (state.status == AuthStatus.successResendVerificationCode) {
          AppSnackBar.showSuccess(
            context: context,
            title: l.success,
            message: state.successMessage ?? l.auth_otp_code_sent,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _authBloc.forms.otpFocus.requestFocus();
          });
          _authBloc.add(const AuthStatusHandled());
        } else if ((state.status == AuthStatus.errorVerifyAccount ||
                state.status == AuthStatus.errorResendVerificationCode) &&
            state.error != null) {
          final message = state.error!.errorCode == 'OTP_INCOMPLETE'
              ? l.auth_otp_incomplete
              : localizedAuthFailureMessage(context, state.error!);
          AppSnackBar.showError(
            context: context,
            title: l.error,
            message: message,
          );
        }
      },
      builder: (_, state) =>
          OtpBody(state: state, email: widget.pendingRegistration.email),
    );
  }
}
