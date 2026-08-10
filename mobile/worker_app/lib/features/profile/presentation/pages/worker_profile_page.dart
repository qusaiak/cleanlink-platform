import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../config/theme/styles.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/worker_profile_bloc.dart';
import '../widgets/availability_selector.dart';
import '../widgets/edit_field_dialog.dart';
import '../widgets/profile_skills_section.dart';
import '../widgets/worker_availability_ui.dart';
import '../widgets/worker_profile_header.dart';
import 'custom_info_tile_card.dart';

/// Screen 2 — the worker's profile: avatar/name/role, availability selector,
/// rating + experience stats, skills, and job id / email / phone / address
/// rows. Name, email, address, phone and the photo are editable via the
/// pencil / camera buttons; everything else is read-only.
///
/// Provides a feature-scoped [WorkerProfileBloc] from `get_it` and loads on
/// open. Kept independent from the settings screen ([ProfilePage]).
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
      backgroundColor: theme.secondaryContainer,
      appBar: customAppBar(
        l.profile,
        Icons.arrow_back_ios_new_rounded, // pushed from the home drawer
        null,
        () => Navigator.of(context).maybePop(),
        theme.primary,
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
                showAppSnackBar(context, message: l.profile_skill_added_message);
                break;
              case WorkerProfileStatus.skillDetached:
                showAppSnackBar(context, message: l.skills_removed_message);
                break;
              case WorkerProfileStatus.skillsFailure:
                // The API's own wording, verbatim; the skills-specific line is
                // used only when the server sent nothing usable at all.
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
            // Until the profile is loaded (initial/loading), show a spinner;
            // if the first load failed, show the error + retry.
            if (state.profile == null) {
              if (state.status == WorkerProfileStatus.error) {
                return _error(context, l, theme);
              }
              return Center(child: spinKitApp(theme.primary));
            }

            final profile = state.profile!;
            // A photo save shows its loading UI on the avatar (preview +
            // spinner), so the blocking full-screen overlay is used only for
            // the text-field edits.
            final saving = state.status == WorkerProfileStatus.savingField &&
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
                      // Busy-aware: shows the locked "Busy" row when derived
                      // busy, otherwise the Available/Off toggle on the base.
                      selected:
                          state.effectiveAvailability ?? profile.availability,
                      updatingTo: state.status == WorkerProfileStatus.updating
                          ? state.updatingTo
                          : null,
                      onChanged: (a) => context
                          .read<WorkerProfileBloc>()
                          .add(ChangeAvailability(a)),
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
                    ProfileSkillsSection(
                      skills: state.ownedSkills,
                      availableSkills: state.availableSkills,
                      loadingSkills: state.loadingSkills,
                      pendingSkillIds: state.pendingSkillIds,
                      // Both act on a single tap — no edit mode, no dialog.
                      onAddSkill: (skill) => context
                          .read<WorkerProfileBloc>()
                          .add(AttachSkill(skill.id)),
                      onRemoveSkill: (skill) => context
                          .read<WorkerProfileBloc>()
                          .add(DetachSkill(skill.id)),
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
                  ],
                ),
                // Blocking overlay while an edit is being saved/uploaded, so
                // the worker can't fire a second edit mid-request.
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

  /// Opens the (bloc-aware) edit dialog for the full name. The dialog shows the
  /// save spinner, closes on success, and surfaces server errors itself.
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

  /// Edits years of experience (non-negative whole number).
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

  /// Camera/gallery sheet for the profile photo (same pattern as the task
  /// photo documentation); the picked file is uploaded as multipart.
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
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
                  leading:
                      Icon(Icons.photo_library_rounded, color: theme.primary),
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
      final XFile? image =
          await picker.pickImage(source: source, imageQuality: 80);
      if (image == null) return;
      // Keep it as an XFile (no File/path conversion) so the multipart upload
      // and the local preview both stay web-compatible. Image-only path — it
      // does NOT go through SaveProfileField, so no other fields are sent.
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
              onPressed: () => context
                  .read<WorkerProfileBloc>()
                  .add(const LoadWorkerProfile()),
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

/// A [StatCard] with a small edit affordance in the corner — used for the
/// editable "years of experience" stat.
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
    return Stack(
      children: [
        StatCard(label: label, value: value, icon: icon, filled: true),
        PositionedDirectional(
          bottom: 4.h,
          end: 4.w,
          child: Material(
            color: Colors.white.withValues(alpha: 0.25),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onEdit,
              child: Padding(
                padding: EdgeInsets.all(5.r),
                child: Icon(Icons.edit_outlined, size: 15.r, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
