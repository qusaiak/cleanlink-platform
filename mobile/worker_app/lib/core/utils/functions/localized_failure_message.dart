import 'package:flutter/widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../error/failure.dart';

String localizedFailureMessage(
  BuildContext context,
  Failure? failure, {
  String? fallback,
}) {
  final l = AppLocalizations.of(context)!;

  switch (failure?.errorCode) {
    case ErrorCode.invalidStatusTransition:
      return l.invalid_status_transition_message;
    case ErrorCode.imagesOnlyWhenDone:
      return l.images_only_when_done_message;
    case ErrorCode.manualBusyNotAllowed:
      return l.manual_busy_not_allowed_message;

    case ErrorCode.noInternet:
    case ErrorCode.tlsHandshakeFailed:
      return l.error_connection;
    case ErrorCode.connectionTimeout:
    case ErrorCode.sendTimeout:
    case ErrorCode.receiveTimeout:
      return l.error_connection_timeout;

    case ErrorCode.emptyCredentials:
      return l.validation_required;
  }

  final message = failure?.message;
  if (message != null && message.isNotEmpty) return message;
  return fallback ?? l.task_action_failed_message;
}
