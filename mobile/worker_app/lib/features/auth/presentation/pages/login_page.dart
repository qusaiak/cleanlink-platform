import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_body.dart';

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
          // Same SnackBar, same styling — only the message resolution changed:
          // `Failure.toString()` printed the wrapper class
          // ("ServerFailure{errorMessage: ...}"), which buried the backend's
          // actual reason. This is the app's standard failure-message resolver.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizedFailureMessage(context, state.error)),
            ),
          );
        }
      },
      builder: (_, state) => LoginBody(state: state),
    );
  }
}
