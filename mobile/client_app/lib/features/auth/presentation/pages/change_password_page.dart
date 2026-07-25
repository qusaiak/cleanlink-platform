import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/change_password_body.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_toast.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        final l = AppLocalizations.of(context)!;
        if (state.status == AuthStatus.successChangePassword) {
          AppSnackBar.showSuccess(
            context: context,
            title: l.success,
            message: state.changePasswordMessage?.isNotEmpty == true
                ? state.changePasswordMessage!
                : l.password_changed_successfully,
          );
          context.pop();
        } else if (state.status == AuthStatus.errorChangePassword) {
          AppSnackBar.showError(
            context: context,
            title: l.error,
            message: _changePasswordErrorMessage(context, state),
          );
        }
      },
      builder: (_, state) => ChangePasswordBody(state: state),
    );
  }

  String _changePasswordErrorMessage(BuildContext context, AuthState state) {
    final l = AppLocalizations.of(context)!;
    if (state.error != null) return state.error!.message;

    switch (state.changePasswordMessage) {
      case 'validation_required':
        return l.validation_required;
      case 'validation_password_short':
        return l.validation_password_short;
      case 'validation_passwords_no_match':
        return l.validation_passwords_no_match;
    }

    return l.error;
  }
}
