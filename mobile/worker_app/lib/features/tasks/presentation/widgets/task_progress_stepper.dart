import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import 'task_status_ui.dart';

class TaskProgressStepper extends StatelessWidget {
  final TaskStatus current;

  const TaskProgressStepper({super.key, required this.current});

  static const _icons = <TaskStatus, IconData>{
    TaskStatus.assigned: Icons.assignment_outlined,
    TaskStatus.onTheWay: Icons.route_outlined,
    TaskStatus.inProgress: Icons.cleaning_services_outlined,
    TaskStatus.completed: Icons.flag_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    const steps = TaskStatusProgression.sequence;
    final currentIndex = steps.indexOf(current).clamp(0, steps.length - 1);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.task_progress_section,
            style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          Directionality(
            textDirection: Directionality.of(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < steps.length; index++) ...[
                  Expanded(
                    child: _Step(
                      status: steps[index],
                      reached: index <= currentIndex,
                      complete: index < currentIndex,
                      current: index == currentIndex,
                    ),
                  ),
                  if (index < steps.length - 1)
                    _Connector(reached: index < currentIndex),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final TaskStatus status;
  final bool reached;
  final bool complete;
  final bool current;

  const _Step({
    required this.status,
    required this.reached,
    required this.complete,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ui = TaskStatusUi.of(context, status);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: reached ? ui.background : colors.surfaceContainerLow,
                shape: BoxShape.circle,
                border: Border.all(
                  color: reached ? ui.color : colors.outlineVariant,
                  width: current ? 2 : 1,
                ),
              ),
              child: Icon(
                TaskProgressStepper._icons[status],
                color: reached ? ui.color : colors.onSurfaceVariant,
                size: 16.r,
              ),
            ),
            if (complete)
            PositionedDirectional(
              top: -4.h,
              end: -4.w,
              child: Container(
                width: 14.r,
                height: 14.r,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface, width: 1.5),
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 9.r,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Directionality(
          textDirection: Directionality.of(context),
          child: Text(
            ui.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle8.copyWith(
              color: reached ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: current ? FontWeight.w700 : FontWeight.w500,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  final bool reached;
  const _Connector({required this.reached});

  @override
  Widget build(BuildContext context) => Container(
    width: 6.w,
    height: 2.h,
    margin: EdgeInsets.only(top: 14.h),
    color: reached
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outlineVariant,
  );
}
