import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_phone_field.dart';
import '../widgets/register_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.successRegister) {
          // final bloc = context.read<AuthBloc>();
          // final phone = fullPhone(
          //   state.selectedCountry,
          //   bloc.forms.registerPhone.text,
          // );
          // context.push(AppRouter.kVerificationAccount, extra: phone);
        // } else if (state. == AuthStatus.error &&
        //     state.errorMessage != null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(state.errorMessage!)),
        //   );
        }
      },
      builder: (_, state) => RegisterBody(state: state),
    );
  }
}
