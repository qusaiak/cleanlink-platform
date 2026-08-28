import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_decoration.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../config/theme/styles.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/worker_profile_bloc.dart';
import '../widgets/availability_selector.dart';
import '../widgets/edit_field_dialog.dart';
import '../widgets/custom_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/worker_availability_ui.dart';
import '../widgets/worker_profile_header.dart';
import 'custom_info_tile_card.dart';

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkerProfileBloc>(
      create: (_) => sl<WorkerProfileBloc>()
        ..add(const LoadWorkerProfile())
        ..add(const LoadAvailableSkills()),
      child: const _WorkerProfileView(),
    );
  }
}

class _WorkerProfileView extends StatelessWidget {
  const _WorkerProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          l.account,
          style: Styles.textStyle18.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<WorkerProfileBloc, WorkerProfileState>(
          listenWhen: (prev, curr) =>
              curr.status == WorkerProfileStatus.updateSuccess ||
              curr.status == WorkerProfileStatus.updateFailure ||
              curr.status == WorkerProfileStatus.saveFieldSuccess ||
              curr.status == WorkerProfileStatus.saveFieldFailure ||
              curr.status == WorkerProfileStatus.skillAttached ||
              curr.status == WorkerProfileStatus.skillDetached ||
              curr.status == WorkerProfileStatus.skillsFailure,
          listener: (context, state) {
            switch (state.status) {
              case WorkerProfileStatus.updateSuccess:
                if (state.profile != null) {
                  final label = WorkerAvailabilityUi.of(
                    context,
                    state.profile!.availability,
                  ).label;
                  showAppSnackBar(
                    context,
                    message: l.availability_updated_message(label),
                  );
                }
                break;
              case WorkerProfileStatus.saveFieldSuccess:
                showAppSnackBar(context, message: l.profile_updated_message);
                break;
              case WorkerProfileStatus.skillAttached:
                showAppSnackBar(
                  context,
                  message: l.profile_skill_added_message,
                );
                break;
              case WorkerProfileStatus.skillDetached:
                showAppSnackBar(context, message: l.skills_removed_message);
                break;
              case WorkerProfileStatus.skillsFailure:
                showAppSnackBar(
                  context,
                  message: localizedFailureMessage(
                    context,
                    state.error,
                    fallback: l.skills_load_failed,
                  ),
                  type: SnackBarType.error,
                );
                break;
              case WorkerProfileStatus.updateFailure:
              case WorkerProfileStatus.saveFieldFailure:
                showAppSnackBar(
                  context,
                  message: localizedFailureMessage(context, state.error),
                  type: SnackBarType.error,
                );
                break;
              default:
                break;
            }
          },
          builder: (context, state) {
            if (state.profile == null) {
              if (state.status == WorkerProfileStatus.error) {
                return _error(context, l, theme);
              }
              return Center(child: spinKitApp(theme.primary));
            }

            final profile = state.profile!;

            final saving =
                state.status == WorkerProfileStatus.savingField &&
                state.pendingImage == null;

            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                  children: [
                    WorkerProfileHeader(
                      profile: profile,
                      effectiveAvailability: state.effectiveAvailability,
                      previewImage: state.pendingImage,
                      uploadingPhoto:
                          state.status == WorkerProfileStatus.savingField,
                      onEditPhoto: () => _editPhoto(context, l),
                      onEditName: () => _editName(context, l, profile.name),
                    ),
                    SizedBox(height: 24.h),
                    AvailabilitySelector(
                      loading: state.loadingOperationalStatus,
                      selected:
                          state.effectiveAvailability ?? profile.availability,
                      updatingTo: state.status == WorkerProfileStatus.updating
                          ? state.updatingTo
                          : null,
                      onChanged: (a) => context.read<WorkerProfileBloc>().add(
                        ChangeAvailability(a),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: l.overall_rating,
                            value: profile.rating.toString(),
                            icon: Icons.star_rounded,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: _EditableStat(
                            label: l.profile_experience_years,
                            value: '${profile.experienceYears}',
                            icon: Icons.work_history_rounded,
                            onEdit: () => _editExperience(
                              context,
                              l,
                              profile.experienceYears,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    SectionCard(
                      title: l.professional_information,
                      children: [
                        CustomTile(
                          icon: Icons.handyman_outlined,
                          title: l.my_skills,
                          subtitle: l.skills_selected_count(
                            state.ownedSkills.length,
                          ),
                          onTap: () => context.push(
                            AppRouter.kSkills,
                            extra: context.read<WorkerProfileBloc>(),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: theme.onSurfaceVariant,
                            size: 15.r,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomInfoTileCard(
                      jobIdLabel: l.job_id_label,
                      jobId: profile.employeeId,
                      emailLabel: l.email,
                      email: profile.email,
                      phoneLabel: l.profile_phone_label,
                      phone: profile.phone,
                      addressLabel: l.profile_address_label,
                      address: profile.address,
                      leaderLabel: l.profile_leader_status_label,
                      leaderValue: profile.isLeader
                          ? l.profile_leader_badge
                          : l.profile_not_leader,
                      isLeader: profile.isLeader,
                      onEditEmail: () => _editEmail(context, l, profile.email),
                      onEditPhone: () => _editPhone(context, l, profile.phone),
                      onEditAddress: () =>
                          _editAddress(context, l, profile.address),
                    ),
                    SizedBox(height: 16.h),
                    const _AccountPreferences(),
                    SizedBox(height: 16.h),
                    const _LogoutCard(),
                  ],
                ),

                if (saving)
                  Positioned.fill(
                    child: ColoredBox(
                      color: theme.surface.withValues(alpha: 0.55),
                      child: Center(child: spinKitApp(theme.primary)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _editName(BuildContext context, AppLocalizations l, String current) {
    showEditFieldDialog(
      context,
      bloc: context.read<WorkerProfileBloc>(),
      title: l.edit_name_title,
      label: l.auth_full_name,
      initialValue: current,
      keyboardType: TextInputType.name,
      validator: (v) => AppValidators.required(v, context),
      buildEvent: (v) => SaveProfileField(fullname: v),
    );
  }

  void _editEmail(BuildContext context, AppLocalizations l, String current) {
    showEditFieldDialog(
      context,
      bloc: context.read<WorkerProfileBloc>(),
      title: l.edit_email_title,
      label: l.email,
      initialValue: current,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => AppValidators.email(v, context),
      buildEvent: (v) => SaveProfileField(email: v),
    );
  }

  void _editPhone(BuildContext context, AppLocalizations l, String current) {
    showEditFieldDialog(
      context,
      bloc: context.read<WorkerProfileBloc>(),
      title: l.edit_phone_title,
      label: l.profile_phone_label,
      initialValue: current,
      keyboardType: TextInputType.phone,
      validator: (v) => AppValidators.phone(v, context),
      buildEvent: (v) => SaveProfileField(phone: v),
    );
  }

  void _editAddress(BuildContext context, AppLocalizations l, String current) {
    showEditFieldDialog(
      context,
      bloc: context.read<WorkerProfileBloc>(),
      title: l.edit_address_title,
      label: l.profile_address_label,
      initialValue: current,
      keyboardType: TextInputType.streetAddress,
      validator: (v) => AppValidators.required(v, context),
      buildEvent: (v) => SaveProfileField(address: v),
    );
  }

  void _editExperience(BuildContext context, AppLocalizations l, int current) {
    showEditFieldDialog(
      context,
      bloc: context.read<WorkerProfileBloc>(),
      title: l.edit_experience_title,
      label: l.profile_experience_years,
      initialValue: '$current',
      keyboardType: TextInputType.number,
      validator: (v) => AppValidators.experienceYears(v, context),
      buildEvent: (v) => SaveProfileField(experienceYears: int.parse(v.trim())),
    );
  }

  void _editPhoto(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context).colorScheme;
    final bloc = context.read<WorkerProfileBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 4.h,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l.edit_photo_title,
                      style: Styles.textStyle16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_rounded, color: theme.primary),
                  title: Text(l.take_photo, style: Styles.textStyle14),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickPhoto(context, l, bloc, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: theme.primary,
                  ),
                  title: Text(l.choose_from_gallery, style: Styles.textStyle14),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickPhoto(context, l, bloc, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPhoto(
    BuildContext context,
    AppLocalizations l,
    WorkerProfileBloc bloc,
    ImageSource source,
  ) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image == null) return;

      bloc.add(SaveProfileImage(image));
    } catch (_) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          message: l.photo_pick_failed_message,
          type: SnackBarType.error,
        );
      }
    }
  }

  Widget _error(BuildContext context, AppLocalizations l, ColorScheme theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56.r, color: theme.error),
            SizedBox(height: 16.h),
            Text(
              l.profile_load_failed,
              textAlign: TextAlign.center,
              style: Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: l.retry,
              width: 160.w,
              height: 46.h,
              onPressed: () => context.read<WorkerProfileBloc>().add(
                const LoadWorkerProfile(),
              ),
              buttonTextStyle: Styles.textStyle14.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountPreferences extends StatelessWidget {
  const _AccountPreferences();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SectionCard(
          title: l.setting_title,
          children: [
            CustomTile(
              icon: state.isLight
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              title: l.appearance,
              onTap: () => context.read<ProfileBloc>().add(ChangeThemeEvent()),
              trailing: Switch.adaptive(
                value: !state.isLight,
                activeTrackColor: colors.primary,
                onChanged: (_) =>
                    context.read<ProfileBloc>().add(ChangeThemeEvent()),
              ),
            ),
            CustomTile(
              icon: Icons.language_rounded,
              title: l.app_lang,
              onTap: () => _confirmLanguageChange(context, l),
              trailing: Text(
                state.languageCode == 'en' ? l.txt_english : l.txt_arabic,
                style: Styles.textStyle12.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomTile(
              icon: Icons.lock_outline_rounded,
              title: l.auth_change_password_title,
              onTap: () => context.push(AppRouter.kChangePassword),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: colors.onSurfaceVariant,
                size: 15.r,
              ),
            ),
          ],
        );
      },
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

class _LogoutCard extends StatelessWidget {
  const _LogoutCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return Material(
      color: colors.errorContainer.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(AppRadius.card.topLeft.x),
      child: InkWell(
        onTap: () => showLogoutDialog(context),
        borderRadius: AppRadius.card,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: colors.error, size: 22.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  l.logout,
                  style: Styles.textStyle14.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colors.error,
                size: 15.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onEdit;

  const _EditableStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final background = colors.primary.withValues(alpha: 0.08);
    final foreground = colors.primary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle12.copyWith(
                    color: foreground.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              Icon(
                icon,
                color: foreground,
                size: 20.r,
              ),

              SizedBox(width: 6.w),

              Material(
                color: foreground.withValues(alpha: 0.14),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEdit,
                  child: Padding(
                    padding: EdgeInsets.all(6.r),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 15.r,
                      color: foreground,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle22.copyWith(
              color: foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}