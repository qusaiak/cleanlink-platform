import 'package:client_app/features/profile/presentation/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../complaints/presentation/bloc/complaints_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_theme_info.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/session/user_session.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';
import 'custom_tile.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListenableBuilder(
          listenable: sl<UserSession>(),
          builder: (context, child) {
            final session = sl<UserSession>();
            final phone = session.phone;

            if (phone == null || phone.isEmpty) {
              return const SizedBox.shrink();
            }

            return SectionCard(
              title: AppLocalizations.of(context)!.personal_details,
              children: [CustomTile(icon: Icons.phone, title: "0$phone")],
            );
          },
        ),
        SectionCard(
          title: AppLocalizations.of(context)!.activity,
          children: [
            CustomTile(
              icon: Icons.location_on_outlined,
              title: AppLocalizations.of(context)!.my_locations,
              onTap: () => GoRouter.of(context).push(AppRouter.kLocations),
            ),
            CustomTile(
              icon: Icons.favorite_border,
              title: AppLocalizations.of(context)!.favorites,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kFavorites);
              },
            ),
            CustomTile(
              icon: Icons.star_border,
              title: AppLocalizations.of(context)!.my_reviews,
              onTap: () => GoRouter.of(context).push(AppRouter.kMyReviews),
            ),
            CustomTile(
              icon: Icons.report_problem_outlined,
              title: AppLocalizations.of(context)!.complaints,
              onTap: () => GoRouter.of(context).push(AppRouter.kComplaints),
              trailing: BlocBuilder<ComplaintsBloc, ComplaintsState>(
                buildWhen: (previous, current) =>
                    previous.unreadCount != current.unreadCount,
                builder: (context, state) => state.unreadCount > 0
                    ? Badge(label: Text('${state.unreadCount}'))
                    : const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColor.primaryColor,
                      ),
              ),
            ),
            CustomTile(
              icon: Icons.payment,
              title: AppLocalizations.of(context)!.payment_history,
              onTap: () => GoRouter.of(context).push(AppRouter.kPaymentHistory),
            ),
          ],
        ),
        SectionCard(
          title: AppLocalizations.of(context)!.setting_title,
          children: [
            CustomTile(
              icon: Icons.language,
              title: AppLocalizations.of(context)!.app_lang,
              onTap: () {
                showAdaptiveDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (dialogContext) => CustomDialog(
                    title: AppLocalizations.of(
                      context,
                    )!.dialog_change_language_title,
                    body: AppLocalizations.of(
                      context,
                    )!.dialog_change_language_body,
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      context.read<ProfileBloc>().add(ChangeLanguageEvent());
                    },
                    onCancel: () {
                      Navigator.of(dialogContext).pop();
                    },
                    cancelButtonText: AppLocalizations.of(context)!.cancel,
                    doneButtonText: AppLocalizations.of(context)!.ok,
                  ),
                );
              },
              trailing: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Text(
                        state.languageCode == "en"
                            ? AppLocalizations.of(context)!.txt_english
                            : AppLocalizations.of(context)!.txt_arabic,
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
                  );
                },
              ),
            ),
            CustomTile(
              icon: Icons.settings_brightness,
              title: AppLocalizations.of(context)!.appearance,
              onTap: () {
                context.read<ProfileBloc>().add(ChangeThemeEvent());
              },
              trailing: AppThemeInfo.isLight
                  ? const Icon(
                      Icons.light_mode_rounded,
                      color: AppColor.primaryColor,
                    )
                  : const Icon(
                      Icons.dark_mode_rounded,
                      color: AppColor.primaryColor,
                    ),
            ),
            CustomTile(
              icon: Icons.notifications_none_outlined,
              title: AppLocalizations.of(context)!.notification_setting,
              trailing: BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.notificationsEnabled !=
                        current.notificationsEnabled ||
                    previous.isUpdatingNotificationPreference !=
                        current.isUpdatingNotificationPreference,
                builder: (context, state) =>
                    state.isUpdatingNotificationPreference
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.primary,
                        ),
                      )
                    : Switch.adaptive(
                        value: state.notificationsEnabled,
                        onChanged: (value) => context.read<ProfileBloc>().add(
                          SetNotificationPreferenceEvent(value),
                        ),
                        activeThumbColor: theme.onPrimary,
                        activeTrackColor: theme.primary,
                        inactiveThumbColor: theme.onSurfaceVariant,
                        inactiveTrackColor: theme.surfaceContainerHighest,
                      ),
              ),
            ),
          ],
        ),
        SectionCard(
          title: AppLocalizations.of(context)!.security,
          children: [
            CustomTile(
              icon: Icons.lock,
              title: AppLocalizations.of(context)!.auth_change_password_title,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kChangePassword);
              },
            ),
            CustomTile(
              icon: Icons.delete,
              title: AppLocalizations.of(context)!.delete_account,
              trailing: const Icon(Icons.warning, color: Colors.red, size: 16),
              onTap: () {
                showAdaptiveDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (dialogContext) =>
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) => CustomDialog(
                          title: AppLocalizations.of(
                            context,
                          )!.dialog_delete_account_title,
                          body: AppLocalizations.of(
                            context,
                          )!.dialog_delete_account_body,
                          isBackButtonDismiss: !state.isDeletingAccount,
                          isLoading: state.isDeletingAccount,
                          onTap: () => context.read<ProfileBloc>().add(
                            DeleteAccountEvent(),
                          ),
                          onCancel: () => Navigator.of(dialogContext).pop(),
                          cancelButtonText: AppLocalizations.of(
                            context,
                          )!.cancel,
                          doneButtonText: AppLocalizations.of(context)!.ok,
                        ),
                      ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
