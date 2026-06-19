import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_detail_bloc.dart';
import '../widgets/task_info_card.dart';
import '../widgets/task_location_banner.dart';
import '../widgets/task_photo_documentation.dart';
import '../widgets/task_status_selector.dart';
import '../widgets/task_status_ui.dart';

/// Screen 3 — full task detail.
///
/// Receives the [task] (via navigation) and provides a [TaskDetailBloc] built
/// with it plus the use cases from `get_it`. Lets the worker review the job,
/// attach before/after photos, pick a new status and submit.
class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskDetailBloc>(
      create: (_) => TaskDetailBloc(
        task: task,
        updateTaskStatus: sl(),
        uploadTaskPhotos: sl(),
      ),
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
            // Return to the list, which refreshes on resume.
            context.pop();
          } else if (state.status == TaskDetailStatus.failure) {
            showAppSnackBar(
              context,
              message: state.error?.message ?? l.task_action_failed_message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<TaskDetailBloc>();
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
                        SizedBox(height: 22.h),
                        TaskStatusSelector(
                          selected: state.selectedStatus,
                          onChanged: (status) =>
                              bloc.add(StatusSelected(status)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Pinned submit button.
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                  child: AppPrimaryButton(
                    label: l.update_status_button,
                    icon: Icons.save_outlined,
                    loading: state.status == TaskDetailStatus.submitting,
                    onPressed: () => bloc.add(const DetailSubmitted()),
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
