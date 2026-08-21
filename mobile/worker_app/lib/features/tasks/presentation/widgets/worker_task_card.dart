import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';
import 'task_status_badge.dart';
import 'task_status_ui.dart';

class WorkerTaskCard extends StatelessWidget {
  const WorkerTaskCard({
    super.key,
    required this.task,
    required this.isActing,
    required this.onTap,
    required this.onAdvance,
    required this.onNavigate,
  });

  final Task task;
  final bool isActing;
  final VoidCallback onTap;
  final VoidCallback onAdvance;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusUi = TaskStatusUi.of(context, task.status);
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final title = task.title.isNotEmpty ? task.title : task.customerName;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.65),
            ),
            boxShadow: AppShadow.card(Theme.of(context).brightness),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: statusUi.background,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: task.imageUrl.isEmpty
                          ? Icon(
                              Icons.cleaning_services_outlined,
                              color: statusUi.color,
                              size: 23.r,
                            )
                          : CachedNetworkImage(
                              imageUrl: task.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Icon(
                                Icons.cleaning_services_outlined,
                                color: statusUi.color,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle16.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l.task_request_number(task.requestNumber),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle11.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  TaskStatusBadge(status: task.status),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: colors.primary,
                      size: 20.r,
                    ),
                    SizedBox(width: 9.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatTaskTime(task.scheduledAt),
                          style: Styles.textStyle16.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          formatTaskDate(task.scheduledAt, locale),
                          style: Styles.textStyle11.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 1,
                      height: 36.h,
                      color: colors.outlineVariant,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: InkWell(
                        onTap: onNavigate,
                        borderRadius: BorderRadius.circular(10.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: colors.primary,
                                size: 19.r,
                              ),
                              SizedBox(width: 7.w),
                              Expanded(
                                child: Text(
                                  task.location,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.textStyle11.copyWith(
                                    color: colors.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (task.customerName.isNotEmpty ||
                  task.companyName.isNotEmpty ||
                  task.price > 0) ...[
                SizedBox(height: 13.h),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: colors.onSurfaceVariant,
                      size: 18.r,
                    ),
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Text(
                        task.customerName.isNotEmpty
                            ? task.customerName
                            : task.companyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.textStyle12.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (task.isTeamLeader)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.warningSoft,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Icon(
                          Icons.workspace_premium_outlined,
                          color: AppColor.warningColor,
                          size: 16.r,
                        ),
                      ),
                    if (task.price > 0) ...[
                      SizedBox(width: 8.w),
                      Text(
                        formatTaskPrice(task.price, task.currency),
                        style: Styles.textStyle14.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              _ActionArea(task: task, isActing: isActing, onAdvance: onAdvance),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionArea extends StatelessWidget {
  const _ActionArea({
    required this.task,
    required this.isActing,
    required this.onAdvance,
  });

  final Task task;
  final bool isActing;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    final next = task.status.next;
    if (next == null || !task.isTeamLeader || task.id.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final isCompletion = next == TaskStatus.completed;
    final buttonColor = isCompletion ? AppColor.successColor : colors.primary;

    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: SizedBox(
        width: double.infinity,
        height: 46.h,
        child: FilledButton.icon(
          onPressed: isActing ? null : onAdvance,
          style: FilledButton.styleFrom(
            backgroundColor: buttonColor,
            disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          icon: isActing
              ? SizedBox.square(
                  dimension: 24.r,
                  child: spinKitApp(colors.onPrimary),
                )
              : Icon(
                  isCompletion
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18.r,
                ),
          label: Text(
            l.task_advance_to(TaskStatusUi.of(context, next).label),
            style: Styles.textStyle12.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
