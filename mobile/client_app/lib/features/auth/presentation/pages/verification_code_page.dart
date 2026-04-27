import 'package:client_app/features/auth/presentation/widgets/verification_code_body.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage(this.gsm, {super.key});

  final String gsm;

  final TextEditingController _pinCode = TextEditingController();

  final FocusNode _pinCodeFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appbarWithBackButton(context, theme),
        body: VerificationCodeBody(
            gsm, _pinCode, _formKey, _pinCodeFocusNode),
      ),
    );
  }
}
