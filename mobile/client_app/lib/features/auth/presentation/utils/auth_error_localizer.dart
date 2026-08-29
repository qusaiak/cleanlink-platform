import 'package:flutter/widgets.dart';

import '../../../../core/auth/user_role.dart';
import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';

String localizedAuthFailureMessage(BuildContext context, Failure failure) {
  final l = AppLocalizations.of(context)!;
  if (failure is InvalidUserRoleFailure) {
    return UserRole.parse(failure.actualRole) == UserRole.worker
        ? l.auth_worker_role_not_allowed
        : l.auth_role_not_allowed;
  }
  if (failure.errorCode == ErrorCode.noInternet) return l.error_connection;
  if (failure.isTimeout) return l.error_connection_timeout;
  if (failure.message.trim().isNotEmpty) return failure.message;
  return l.auth_error_generic;
}
