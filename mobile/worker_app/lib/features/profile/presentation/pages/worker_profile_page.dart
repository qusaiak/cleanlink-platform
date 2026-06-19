import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/functions/build_app_snack_bar.dart';
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
import '../widgets/worker_availability_ui.dart';
import '../widgets/worker_profile_header.dart';
import 'custom_info_tile_card.dart';

/// Screen 2 — the worker's profile: avatar/name/role, availability selector,
/// rating + completed-tasks stats, and job id / email rows.
///
/// Provides a feature-scoped [WorkerProfileBloc] from `get_it` and loads on
/// open. Kept independent from the settings screen ([ProfilePage]).
class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkerProfileBloc>(
      create: (_) => sl<WorkerProfileBloc>()..add(const LoadWorkerProfile()),
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
        l.task_management_title,
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
              curr.status == WorkerProfileStatus.saveFieldFailure,
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
              case WorkerProfileStatus.updateFailure:
              case WorkerProfileStatus.saveFieldFailure:
                showAppSnackBar(
                  context,
                  message: state.error?.message ?? l.task_action_failed_message,
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
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              children: [
                WorkerProfileHeader(profile: profile),
                SizedBox(height: 24.h),
                AvailabilitySelector(
                  selected: profile.availability,
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
                      child: StatCard(
                        label: l.completed_tasks_count,
                        value: '${profile.completedTasks}',
                        icon: Icons.check_circle_rounded,
                        filled: true,
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
                  onEditJobId: () => _editJobId(context, l, profile.employeeId),
                  onEditEmail: () => _editEmail(context, l, profile.email),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Opens the edit dialog for the email and, on save, dispatches the update.
  Future<void> _editEmail(
    BuildContext context,
    AppLocalizations l,
    String current,
  ) async {
    final bloc = context.read<WorkerProfileBloc>();
    final value = await showEditFieldDialog(
      context,
      title: l.edit_email_title,
      label: l.email,
      initialValue: current,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => AppValidators.email(v, context),
    );
    if (value != null) bloc.add(SaveProfileField(email: value));
  }

  /// Opens the edit dialog for the employee id and, on save, dispatches it.
  Future<void> _editJobId(
    BuildContext context,
    AppLocalizations l,
    String current,
  ) async {
    final bloc = context.read<WorkerProfileBloc>();
    final value = await showEditFieldDialog(
      context,
      title: l.edit_job_id_title,
      label: l.job_id_label,
      initialValue: current,
      validator: (v) => AppValidators.required(v, context),
    );
    if (value != null) bloc.add(SaveProfileField(employeeId: value));
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
