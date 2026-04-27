import 'package:flutter/material.dart';

/// Text controllers, [FocusNode]s, and [FormState] keys for auth screens.
/// Owned by [AuthCubit] and disposed in [AuthCubit.close].
class AuthFormControllers {
  AuthFormControllers();

  // ── Login ─────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController loginPhone = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();
  final FocusNode loginPhoneFocus = FocusNode();
  final FocusNode loginPasswordFocus = FocusNode();

  // ── Register ────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController registerName = TextEditingController();
  final TextEditingController registerPhone = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();
  final TextEditingController registerBirthDateDisplay = TextEditingController();
  final FocusNode registerNameFocus = FocusNode();
  final FocusNode registerPhoneFocus = FocusNode();
  final FocusNode registerPasswordFocus = FocusNode();
  final FocusNode registerConfirmFocus = FocusNode();

  // ── OTP ───────────────────────────────────────────────────────────────────
  final TextEditingController otpCode = TextEditingController();
  final FocusNode otpFocus = FocusNode();

  // ── Forgot password ───────────────────────────────────────────────────────
  final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();
  final TextEditingController forgotPhone = TextEditingController();
  final FocusNode forgotPhoneFocus = FocusNode();

  // ── Reset password ────────────────────────────────────────────────────────
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();
  final TextEditingController resetNewPassword = TextEditingController();
  final TextEditingController resetConfirmPassword = TextEditingController();
  final FocusNode resetNewFocus = FocusNode();
  final FocusNode resetConfirmFocus = FocusNode();

  // ── Change password ─────────────────────────────────────────────────────────
  final GlobalKey<FormState> changeFormKey = GlobalKey<FormState>();
  final TextEditingController changeOldPassword = TextEditingController();
  final TextEditingController changeNewPassword = TextEditingController();
  final TextEditingController changeConfirmPassword = TextEditingController();
  final FocusNode changeOldFocus = FocusNode();
  final FocusNode changeNewFocus = FocusNode();
  final FocusNode changeConfirmFocus = FocusNode();

  void dispose() {
    loginPhone.dispose();
    loginPassword.dispose();
    loginPhoneFocus.dispose();
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

    forgotPhone.dispose();
    forgotPhoneFocus.dispose();

    resetNewPassword.dispose();
    resetConfirmPassword.dispose();
    resetNewFocus.dispose();
    resetConfirmFocus.dispose();

    changeOldPassword.dispose();
    changeNewPassword.dispose();
    changeConfirmPassword.dispose();
    changeOldFocus.dispose();
    changeNewFocus.dispose();
    changeConfirmFocus.dispose();
  }
}
