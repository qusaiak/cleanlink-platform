import 'package:flutter/material.dart';

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
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();
  final TextEditingController registerBirthDateDisplay =
      TextEditingController();
  final FocusNode registerNameFocus = FocusNode();
  final FocusNode registerEmailFocus = FocusNode();
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

  void clearSensitiveRegistrationData() {
    registerPassword.clear();
    registerConfirmPassword.clear();
    otpCode.clear();
  }

  void dispose() {
    loginEmail.dispose();
    loginPassword.dispose();
    loginEmailFocus.dispose();
    loginPasswordFocus.dispose();

    registerName.dispose();
    registerEmail.dispose();
    registerPassword.dispose();
    registerConfirmPassword.dispose();
    registerBirthDateDisplay.dispose();
    registerNameFocus.dispose();
    registerEmailFocus.dispose();
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
