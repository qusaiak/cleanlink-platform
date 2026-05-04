import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/change_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state.status == AuthStatus.ChangeSent) {
        //   context.push(AppRouter.kResetPassword);
        // }
      },
      builder: (_, state) => ChangePasswordBody(state: state),
    );
  }
}
