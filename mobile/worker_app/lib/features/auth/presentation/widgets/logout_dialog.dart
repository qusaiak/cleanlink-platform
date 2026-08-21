import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/logout_usecase.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _LogoutDialog(),
  );
}

class _LogoutDialog extends StatefulWidget {
  const _LogoutDialog();

  @override
  State<_LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<_LogoutDialog> {
  bool _loading = false;

  Future<void> _confirm() async {
    if (_loading) return;
    final l = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    setState(() => _loading = true);

    final result = await sl<LogoutUsecase>()();

    await clearSession();

    navigator.pop();
    AppRouter.router.go(AppRouter.kLogin);

    if (result.isLeft()) {
      showToast(text: l.logout_failed_message, state: ToastState.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_loading,
      child: AlertDialog(
        backgroundColor: theme.surface,
        surfaceTintColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        title: Text(
          l.logout,
          style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          l.logout_confirm_message,
          style: Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: _loading ? null : () => Navigator.of(context).pop(),
            child: Text(
              l.cancel,
              style: Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: _loading ? null : _confirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.error,
              disabledBackgroundColor: theme.error.withValues(alpha: 0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
            ),
            child: _loading
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: spinKitApp(theme.onError),
                  )
                : Text(
                    l.logout,
                    style: Styles.textStyle14.copyWith(
                      color: theme.onError,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
