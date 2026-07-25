import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/register_body.dart';
import 'package:client_app/features/auth/presentation/utils/auth_error_localizer.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.successRegister) {
          final pending = state.pendingRegistration;
          if (pending == null) return;
          AppSnackBar.showSuccess(
            context: context,
            title: AppLocalizations.of(context)!.success,
            message:
                state.successMessage ??
                AppLocalizations.of(context)!.auth_otp_code_sent,
          );
          context.read<AuthBloc>().add(const AuthStatusHandled());
          context.push(AppRouter.kOtp, extra: pending);
        } else if (state.status == AuthStatus.errorRegister &&
            state.error != null) {
          AppSnackBar.showError(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: localizedAuthFailureMessage(context, state.error!),
          );
        }
      },
      builder: (_, state) => RegisterBody(state: state),
    );
  }
}
