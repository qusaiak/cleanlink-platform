import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/otp_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state.authStatus == AuthStatus.otpVerified) {
        //   context.go(AppRouter.kHomePage);
        // }
      },
      builder: (_, state) => OtpBody(state: state, phoneLabel: phone),
    );
  }
}
