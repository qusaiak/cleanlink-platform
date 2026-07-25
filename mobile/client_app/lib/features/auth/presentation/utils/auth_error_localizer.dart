import 'package:flutter/widgets.dart';

import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';

String localizedAuthFailureMessage(BuildContext context, Failure failure) {
  final l = AppLocalizations.of(context)!;
  if (failure.errorCode == ErrorCode.noInternet) return l.error_connection;
  if (failure.isTimeout) return l.error_connection_timeout;
  if (failure.message.trim().isNotEmpty) return failure.message;
  return l.auth_error_generic;
}
