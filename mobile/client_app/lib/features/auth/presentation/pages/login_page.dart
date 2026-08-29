import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/login_body.dart';
import 'package:client_app/features/auth/presentation/utils/auth_error_localizer.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.successLogin) {
          context.go(AppRouter.kHome);
        } else if (state.status == AuthStatus.errorLogin &&
            state.error != null) {
          AppSnackBar.showError(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: localizedAuthFailureMessage(context, state.error!),
          );
        }
      },
      builder: (_, state) => LoginBody(state: state),
    );
  }
}
