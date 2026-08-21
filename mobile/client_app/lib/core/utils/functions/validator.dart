import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

class AppValidators {
  const AppValidators._();

  static String? required(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) return l.validation_required;
    return null;
  }

  static String? name(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().length < 2) {
      return l.validation_required_name;
    }
    return null;
  }

  static String? email(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l.validation_email_required;
    }

    const pattern = r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$';

    if (!RegExp(pattern).hasMatch(value.trim())) {
      return l.validation_email_invalid;
    }

    return null;
  }

  static String? phone(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final v = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (v.length < 9) return l.validation_phone_invalid;
    return null;
  }

  static String? password(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final v = value ?? '';
    if (v.length < 8) return l.validation_password_short;
    if (!RegExp(r'[A-Z]').hasMatch(v)) return l.validation_password_uppercase;
    if (!RegExp(r'\d').hasMatch(v)) return l.validation_password_number;
    return null;
  }

  static String? confirmPassword(
    String? value,
    String original,
    BuildContext context,
  ) {
    final l = AppLocalizations.of(context)!;
    if (value != original) return l.validation_passwords_no_match;
    return null;
  }

  static String? age18(DateTime? date, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (date == null) return l.validation_required;
    final now = DateTime.now();
    final eighteenAgo = DateTime(now.year - 18, now.month, now.day);
    if (date.isAfter(eighteenAgo)) return l.validation_age_18;
    return null;
  }

  static String? empty(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l.empty_field_error_message;
    return null;
  }

  static String? gsm(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l.empty_field_error_message;
    if (value.length < 10 || !value.startsWith('09')) {
      return l.invalid_mobile_number_error_message;
    }
    return null;
  }

  static String? validateCode(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if ((value ?? '').length < 4) return l.empty_field_error_message;
    return null;
  }
}

class PasswordStrength {
  const PasswordStrength._();

  static double score(String password) {
    if (password.isEmpty) return 0;
    double s = 0;
    if (password.length >= 8) s += 0.25;
    if (password.length >= 12) s += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(password)) s += 0.2;
    if (RegExp(r'[a-z]').hasMatch(password)) s += 0.1;
    if (RegExp(r'\d').hasMatch(password)) s += 0.15;
    if (RegExp(
      r'[!@#\$%\^&\*\(\)_\-\+=\[\]\{\};:,\.<>\?/\\|`~"]',
    ).hasMatch(password)) {
      s += 0.15;
    }
    return s.clamp(0, 1).toDouble();
  }
}
