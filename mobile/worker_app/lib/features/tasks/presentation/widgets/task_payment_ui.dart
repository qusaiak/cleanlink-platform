import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';

class TaskPaymentUi {
  const TaskPaymentUi._();

  static String methodLabel(BuildContext context, String code) {
    final l = AppLocalizations.of(context)!;
    switch (code) {
      case 'manual':
        return l.payment_method_manual;
      case 'electric':
        return l.payment_method_electric;
      default:
        return code;
    }
  }

  static String statusLabel(BuildContext context, String code) {
    final l = AppLocalizations.of(context)!;
    switch (code) {
      case 'pending':
        return l.payment_status_pending;
      case 'held':
        return l.payment_status_held;
      case 'paid':
        return l.payment_status_paid;
      case 'captured':
        return l.payment_status_captured;
      case 'failed':
        return l.payment_status_failed;
      default:
        return code;
    }
  }

  static Color statusColor(BuildContext context, String code) {
    switch (code) {
      case 'paid':
      case 'captured':
        return AppColor.successColor;
      case 'failed':
        return Theme.of(context).colorScheme.error;
      case 'held':
        return AppColor.infoColor;
      default:
        return AppColor.warningColor;
    }
  }
}
