import 'package:flutter/widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../error/failure.dart';

/// Resolves the user-facing message for a [Failure].
///
/// Two distinct kinds of failure, deliberately treated differently:
///
///  - Failures that never reached the server — client-side
///    [ValidationFailure]s and transport errors (no connection, timeout) —
///    have no server wording, so they map from their stable error code onto
///    the app's own translated string. Their `message` is an English log-side
///    fallback only.
///
///  - Failures the SERVER produced already carry its message, extracted by
///    `parseApiError` and kept verbatim (the API answers in the right language
///    — the app sends `Accept-Language` on every request). It is shown exactly
///    as returned: never translated, rewritten or decorated here.
///
/// When nothing usable came back, [fallback] (or the app's generic error) is
/// used — this is the single place that generic sentence is chosen, so the
/// data layer never has to invent one.
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
    // Transport-level: the request never produced a server message.
    case ErrorCode.noInternet:
    // A TLS handshake failure is a connection problem as far as the worker is
    // concerned; the precise cause (bad certificate vs. https:// aimed at a
    // plain-HTTP dev server) is developer detail and stays in the log.
    case ErrorCode.tlsHandshakeFailed:
      return l.error_connection;
    case ErrorCode.connectionTimeout:
    case ErrorCode.sendTimeout:
    case ErrorCode.receiveTimeout:
      return l.error_connection_timeout;
    // Caught before the request was sent.
    case ErrorCode.emptyCredentials:
      return l.validation_required;
  }

  final message = failure?.message;
  if (message != null && message.isNotEmpty) return message;
  return fallback ?? l.task_action_failed_message;
}
