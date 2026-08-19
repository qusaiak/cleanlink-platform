import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/widgets/custom_tile.dart';
import '../../../profile/presentation/widgets/section_card.dart';

/// Settings screen reached from the home drawer.
///
/// Lets the worker switch the app theme (light/dark) and language (Arabic/
/// English). Both are driven by the root-provided [ProfileBloc] — the same
/// events the app already uses to rebuild [MaterialApp]'s theme and locale.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.secondaryContainer,
      appBar: customAppBar(
        l.setting_title,
        Icons.arrow_back_ios_new_rounded,
        null,
        () => Navigator.of(context).maybePop(),
        theme.primary,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                SectionCard(
                  title: l.appearance,
                  children: [
                    // Theme — tap to flip light/dark instantly.
                    CustomTile(
                      icon: Icons.settings_brightness,
                      title: l.appearance,
                      onTap: () =>
                          context.read<ProfileBloc>().add(ChangeThemeEvent()),
                      trailing: Icon(
                        state.isLight
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: theme.primary,
                      ),
                    ),
                    // Language — confirm, then toggle Arabic/English.
                    CustomTile(
                      icon: Icons.language,
                      title: l.app_lang,
                      onTap: () => _confirmLanguageChange(context, l),
                      trailing: Row(
                        children: [
                          Text(
                            state.languageCode == 'en'
                                ? l.txt_english
                                : l.txt_arabic,
                            style: Styles.textStyle12.copyWith(
                              color: theme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: theme.primary,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SectionCard(
                  title: l.account,
                  children: [
                    // Change password — opens the dedicated change-password
                    // screen (PUT /api/auth/change-password).
                    CustomTile(
                      icon: Icons.lock_outline_rounded,
                      title: l.auth_change_password_title,
                      onTap: () => context.push(AppRouter.kChangePassword),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: theme.primary,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmLanguageChange(BuildContext context, AppLocalizations l) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomDialog(
        title: l.dialog_change_language_title,
        body: l.dialog_change_language_body,
        cancelButtonText: l.cancel,
        doneButtonText: l.ok,
        onCancel: () => Navigator.of(dialogContext).pop(),
        onTap: () {
          context.read<ProfileBloc>().add(ChangeLanguageEvent());
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}
