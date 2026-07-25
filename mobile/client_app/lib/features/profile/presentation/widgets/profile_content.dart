import 'package:client_app/features/profile/presentation/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    return Column(
      children: [
        ListenableBuilder(
          listenable: sl<UserSession>(),
          builder: (context, child) {
            final session = sl<UserSession>();
            final phone = session.phone;
            final address = session.address;

            if ((phone == null || phone.isEmpty) &&
                (address == null || address.isEmpty)) {
              return const SizedBox.shrink();
            }

            return SectionCard(
              title: AppLocalizations.of(context)!.personal_details,
              children: [
                CustomTile(icon: Icons.phone, title: "0$phone"),
                CustomTile(icon: Icons.location_on, title: address!),
              ],
            );
          },
        ),
        SectionCard(
          title: AppLocalizations.of(context)!.activity,
          children: [
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
              icon: Icons.payment,
              title: AppLocalizations.of(context)!.payment_history,
              onTap: () {},
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
              trailing: AppThemeInfo.isLight!
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
              trailing: SizedBox(
                height: 30.h,
                width: 40.w,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch.adaptive(
                    value: true,
                    onChanged: (value) {},
                    activeColor: AppColor.onPrimaryLight,
                    activeTrackColor: theme.primary,
                    inactiveThumbColor: const Color(0xFFD6D8DA),
                    inactiveTrackColor: AppColor.onPrimaryLight,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
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
        SectionCard(
          title: AppLocalizations.of(context)!.support,
          children: [
            CustomTile(
              icon: Icons.help_outline,
              title: AppLocalizations.of(context)!.help_center_title,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kHelpCenter);
              },
            ),
            CustomTile(
              icon: Icons.contact_mail,
              title: AppLocalizations.of(context)!.contact_us,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kContactUs);
              },
            ),
            // CustomTile(
            //   icon: Icons.feedback,
            //   title: AppLocalizations.of(context)!.suggestions,
            // ),
          ],
        ),
        SizedBox(height: 24.h),
        Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  // onTap: () =>
                  //     _launchUrl('https://privacy-policy'),
                  child: Text(
                    AppLocalizations.of(context)!.privacy_policy,
                    style: Styles.textStyle12.copyWith(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    "|",
                    style: Styles.textStyle11.copyWith(color: Colors.grey),
                  ),
                ),
                GestureDetector(
                  // onTap: () =>
                  //     _launchUrl('https://terms-of-use'),
                  child: Text(
                    AppLocalizations.of(context)!.terms_of_use,
                    style: Styles.textStyle12.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              "v 1.0",
              style: Styles.textStyle11.copyWith(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
