import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.logoutSuccess) {
            AppSnackBar.showSuccess(
              context: context,
              title: l.success,
              message: l.logout_successfully,
            );
            context.go(AppRouter.kLogin);
          } else if (state.status == ProfileStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.showError(
              context: context,
              title: l.error,
              message: _localizedProfileMessage(state.errorMessage, l),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: customAppBar(
              l.my_profile,
              null,
              [
                GestureDetector(
                  onTap: state.isLoggingOut
                      ? null
                      : () => _confirmLogout(context),
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Row(
                      children: [
                        Text(
                          l.logout,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: theme.onSurface,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        state.isLoggingOut
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.logout_outlined, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
              () {},
              theme.onSurface,
            ),
            body: const ProfileBody(),
          );
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomDialog(
        title: l.logout,
        body: l.logout_confirmation,
        onTap: () {
          Navigator.of(dialogContext).pop();
          context.read<ProfileBloc>().add(LogoutEvent());
        },
        onCancel: () => Navigator.of(dialogContext).pop(),
        cancelButtonText: l.cancel,
        doneButtonText: l.logout,
      ),
    );
  }

  String _localizedProfileMessage(String? message, AppLocalizations l) {
    return switch (message) {
      'failed_to_logout' => l.failed_to_logout,
      _ => message ?? l.failed_to_logout,
    };
  }
}
