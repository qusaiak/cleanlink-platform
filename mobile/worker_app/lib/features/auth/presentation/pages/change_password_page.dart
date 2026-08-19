import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/change_password_body.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr.status == AuthStatus.successChangePassword ||
            curr.status == AuthStatus.errorChangePassword,
        listener: (context, state) {
          final l = AppLocalizations.of(context)!;
          if (state.status == AuthStatus.successChangePassword) {
            showAppSnackBar(
              context,
              message: l.password_changed_successfully,
              type: SnackBarType.success,
            );
            // Clear the form fields after a successful change.
            final bloc = context.read<AuthBloc>();
            bloc.forms.changeOldPassword.clear();
            bloc.forms.changeNewPassword.clear();
            bloc.forms.changeConfirmPassword.clear();
            Navigator.of(context).maybePop();
          } else if (state.status == AuthStatus.errorChangePassword) {
            showAppSnackBar(
              context,
              message: localizedFailureMessage(context, state.error),
              type: SnackBarType.error,
            );
          }
        },
        builder: (_, state) => ChangePasswordBody(state: state),
      ),
    );
  }
}
