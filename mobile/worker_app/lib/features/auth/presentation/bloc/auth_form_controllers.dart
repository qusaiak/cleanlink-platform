import 'package:flutter/material.dart';

/// Text controllers, [FocusNode]s, and [FormState] keys for auth screens.
/// Owned by [AuthBloc] and disposed in [AuthBloc.close].
class AuthFormControllers {
  AuthFormControllers();

  // ── Login ─────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();
  final FocusNode loginEmailFocus = FocusNode();
  final FocusNode loginPasswordFocus = FocusNode();

  // ── Register ────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController registerName = TextEditingController();
  final TextEditingController registerPhone = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();
  final TextEditingController registerBirthDateDisplay =
      TextEditingController();
  final FocusNode registerNameFocus = FocusNode();
  final FocusNode registerPhoneFocus = FocusNode();
  final FocusNode registerPasswordFocus = FocusNode();
  final FocusNode registerConfirmFocus = FocusNode();

  // ── OTP ───────────────────────────────────────────────────────────────────
  final TextEditingController otpCode = TextEditingController();
  final FocusNode otpFocus = FocusNode();

  // ── Change password ─────────────────────────────────────────────────────────
  final GlobalKey<FormState> changeFormKey = GlobalKey<FormState>();
  final TextEditingController changeOldPassword = TextEditingController();
  final TextEditingController changeNewPassword = TextEditingController();
  final TextEditingController changeConfirmPassword = TextEditingController();
  final FocusNode changeOldFocus = FocusNode();
  final FocusNode changeNewFocus = FocusNode();
  final FocusNode changeConfirmFocus = FocusNode();

  void dispose() {
    loginEmail.dispose();
    loginPassword.dispose();
    loginEmailFocus.dispose();
    loginPasswordFocus.dispose();

    registerName.dispose();
    registerPhone.dispose();
    registerPassword.dispose();
    registerConfirmPassword.dispose();
    registerBirthDateDisplay.dispose();
    registerNameFocus.dispose();
    registerPhoneFocus.dispose();
    registerPasswordFocus.dispose();
    registerConfirmFocus.dispose();

    otpCode.dispose();
    otpFocus.dispose();

    changeOldPassword.dispose();
    changeNewPassword.dispose();
    changeConfirmPassword.dispose();
    changeOldFocus.dispose();
    changeNewFocus.dispose();
    changeConfirmFocus.dispose();
  }
}
