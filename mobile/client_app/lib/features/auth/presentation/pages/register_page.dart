import 'package:client_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/register_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appbarWithBackButton(context, theme),
        body: RegisterBody(),
      ),
    );
  }
}
