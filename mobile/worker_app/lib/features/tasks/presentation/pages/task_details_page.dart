import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_detail_bloc.dart';
import '../widgets/task_info_card.dart';
import '../widgets/task_location_banner.dart';
import '../widgets/task_photo_documentation.dart';
import '../widgets/task_progress_stepper.dart';
import '../widgets/task_status_ui.dart';

/// Screen 3 — full task detail.
///
/// Receives the [task] (via navigation) and provides a [TaskDetailBloc] built
/// with it plus the use case from `get_it`. Shows the strict progress stepper
/// (`pending → on_way → handling → done`) and a single button that advances
/// only to the next allowed status; the before/after photo pickers appear
/// exclusively on the final (`done`) step, matching the API contract.
class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskDetailBloc>(
      create: (_) => TaskDetailBloc(task: task, updateTaskStatus: sl()),
      child: const _TaskDetailsView(),
    );
  }
}

class _TaskDetailsView extends StatelessWidget {
  const _TaskDetailsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.secondaryContainer,
      appBar: customAppBar(
        l.task_management_title,
        Icons.arrow_back_ios_new_rounded,
        null,
        () => context.pop(),
        theme.primary,
      ),
      body: BlocConsumer<TaskDetailBloc, TaskDetailState>(
        listenWhen: (prev, curr) =>
            curr.status == TaskDetailStatus.success ||
            curr.status == TaskDetailStatus.failure,
        listener: (context, state) {
          if (state.status == TaskDetailStatus.success) {
            final statusLabel =
                TaskStatusUi.of(context, state.task.status).label;
            showAppSnackBar(
              context,
              message: l.task_status_updated_message(statusLabel),
            );
            // Return to the list, handing back the updated task so the list
            // (the single source of truth) reflects the new status at once.
            context.pop(state.task);
          } else if (state.status == TaskDetailStatus.failure) {
            showAppSnackBar(
              context,
              message: localizedFailureMessage(context, state.error),
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<TaskDetailBloc>();
          final next = state.nextStatus;

          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskLocationBanner(task: state.task),
                        SizedBox(height: 16.h),
                        TaskInfoCard(task: state.task),
                        SizedBox(height: 22.h),
                        // Progress through the strict sequence — visible to the
                        // whole crew; only the leader can advance it below.
                        TaskProgressStepper(current: state.task.status),
                        // The photo pickers exist ONLY while marking the task
                        // done (the API accepts images with no other status).
                        if (state.task.isTeamLeader &&
                            state.isMarkingDone) ...[
                          SizedBox(height: 22.h),
                          TaskPhotoDocumentation(
                            beforeExisting: state.task.beforePhotos,
                            afterExisting: state.task.afterPhotos,
                            beforeNew: state.newBeforePhotos,
                            afterNew: state.newAfterPhotos,
                            onPicked: (isBefore, path) => bloc.add(
                              PhotoAdded(path: path, isBefore: isBefore),
                            ),
                            onRemoveNew: (isBefore, index) => bloc.add(
                              PhotoRemoved(index: index, isBefore: isBefore),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                // Pinned advance button — leader only, and only while there is
                // a next status to move to.
                if (state.task.isTeamLeader && next != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                    child: AppPrimaryButton(
                      label: l.task_advance_to(
                        TaskStatusUi.of(context, next).label,
                      ),
                      icon: next == TaskStatus.completed
                          ? Icons.check_circle_outline_rounded
                          : Icons.arrow_forward_rounded,
                      loading: state.status == TaskDetailStatus.submitting,
                      onPressed: () => bloc.add(const AdvanceStatusSubmitted()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
