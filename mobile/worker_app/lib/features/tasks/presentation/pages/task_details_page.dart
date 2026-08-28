import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../config/theme/styles.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_detail_bloc.dart';
import '../widgets/task_header_card.dart';
import '../widgets/task_details_sections.dart';
import '../widgets/task_location_banner.dart';
import '../widgets/task_photo_documentation.dart';
import '../widgets/task_progress_stepper.dart';
import '../widgets/task_status_ui.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskDetailBloc>(
      create: (_) =>
          TaskDetailBloc(task: task, updateTaskStatus: sl(), getTaskById: sl()),
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
      backgroundColor: theme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          l.task_management_title,
          style: Styles.textStyle18.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<TaskDetailBloc, TaskDetailState>(
        listenWhen: (prev, curr) =>
            curr.status == TaskDetailStatus.success ||
            curr.status == TaskDetailStatus.failure,
        listener: (context, state) {
          if (state.status == TaskDetailStatus.success) {
            final statusLabel = TaskStatusUi.of(
              context,
              state.task.status,
            ).label;
            showAppSnackBar(
              context,
              message: l.task_status_updated_message(statusLabel),
            );

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

          if (state.status == TaskDetailStatus.loading) {
            return SafeArea(
              top: false,
              child: Center(child: spinKitApp(theme.primary)),
            );
          }

          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.status == TaskDetailStatus.loadFailure) ...[
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: theme.errorContainer,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    localizedFailureMessage(
                                      context,
                                      state.error,
                                    ),
                                    style: Styles.textStyle12.copyWith(
                                      color: theme.onErrorContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      bloc.add(const LoadTaskDetails()),
                                  child: Text(l.retry),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        TaskHeaderCard(task: state.task),
                        SizedBox(height: 16.h),
                        TaskProgressStepper(current: state.task.status),
                        SizedBox(height: 16.h),
                        TaskScheduleCard(task: state.task),
                        if (state.task.location.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          TaskLocationBanner(task: state.task),
                        ],
                        SizedBox(height: 16.h),
                        TaskServicePackageCard(task: state.task),
                        if (state.task.customerName.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          TaskClientCard(task: state.task),
                        ],
                        if (state.task.teamMembers.isNotEmpty ||
                            state.task.leaderName.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          TaskTeamCard(task: state.task),
                        ],
                        if (state.task.price > 0 ||
                            state.task.paymentMethod.isNotEmpty ||
                            state.task.paymentStatus.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          TaskPaymentCard(task: state.task),
                        ],
                        if (state.task.details.trim().isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          TaskNotesCard(task: state.task),
                        ],

                        if (state.task.beforePhotos.isNotEmpty ||
                            state.task.afterPhotos.isNotEmpty ||
                            (state.task.isTeamLeader &&
                                state.isMarkingDone)) ...[
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              color: theme.surface,
                              borderRadius: BorderRadius.circular(22.r),
                              border: Border.all(color: theme.outlineVariant),
                            ),
                            child: TaskPhotoDocumentation(
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
                              canEdit:
                                  state.task.isTeamLeader &&
                                  state.isMarkingDone,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                if (state.task.isTeamLeader &&
                    state.task.id.isNotEmpty &&
                    next != null)
                  Container(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      border: Border(
                        top: BorderSide(color: theme.outlineVariant),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: AppPrimaryButton(
                        label: l.task_advance_to(
                          TaskStatusUi.of(context, next).label,
                        ),
                        icon: next == TaskStatus.completed
                            ? Icons.check_circle_outline_rounded
                            : Icons.arrow_forward_rounded,
                        loading: state.status == TaskDetailStatus.submitting,
                        onPressed: () =>
                            bloc.add(const AdvanceStatusSubmitted()),
                      ),
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
