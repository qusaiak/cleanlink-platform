import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/change_password_body.dart';

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
