import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';

class TaskPaymentUi {
  const TaskPaymentUi._();

  static String methodLabel(BuildContext context, String code) {
    final l = AppLocalizations.of(context)!;
    switch (code) {
      case 'cash':
        return l.payment_method_cash;
      case 'card':
        return l.payment_method_card;
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
      case 'captured':
        return l.payment_status_captured;
      case 'refunded':
        return l.payment_status_refunded;
      case 'failed':
        return l.payment_status_failed;
      default:
        return code;
    }
  }

  static Color statusColor(BuildContext context, String code) {
    switch (code) {
      case 'captured':
        return AppColor.successColor;
      case 'refunded':
        return AppColor.infoColor;
      case 'failed':
        return Theme.of(context).colorScheme.error;
      case 'held':
        return AppColor.infoColor;
      default:
        return AppColor.warningColor;
    }
  }
}
