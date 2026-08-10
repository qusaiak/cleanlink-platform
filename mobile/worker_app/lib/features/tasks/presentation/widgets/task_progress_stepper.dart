import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import 'task_status_ui.dart';

/// Progress timeline for the strict task sequence
/// `pending → on_way → handling → done`.
///
/// Each of the four statuses is a node: completed steps show a check, the
/// current step is highlighted with its status colour, and upcoming steps are
/// muted. Because the flow is strictly sequential the stepper is display-only —
/// advancing happens through the single submit button underneath, never by
/// tapping a node.
///
/// Rows mirror automatically between Arabic (RTL) and English (LTR).
class TaskProgressStepper extends StatelessWidget {
  /// The task's current status. Legacy statuses outside the sequence
  /// (paused/cancelled) simply render with no active node.
  final TaskStatus current;

  const TaskProgressStepper({super.key, required this.current});

  static const _icons = {
    TaskStatus.assigned: Icons.assignment_outlined,
    TaskStatus.onTheWay: Icons.directions_car_filled_outlined,
    TaskStatus.inProgress: Icons.cleaning_services_outlined,
    TaskStatus.completed: Icons.check_circle_outline_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    const sequence = TaskStatusProgression.sequence;
    final currentIndex = sequence.indexOf(current);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context, l.task_progress_section),
        SizedBox(height: 14.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < sequence.length; i++) ...[
              _node(
                context,
                status: sequence[i],
                isDone: currentIndex >= 0 && i < currentIndex,
                isCurrent: i == currentIndex,
              ),
              if (i < sequence.length - 1)
                Expanded(
                  child: _connector(
                    context,
                    reached: currentIndex >= 0 && i < currentIndex,
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _title(BuildContext context, String text) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.route_rounded, size: 18.r, color: theme.primary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// One step: a circled icon (check once passed) with its label underneath.
  Widget _node(
    BuildContext context, {
    required TaskStatus status,
    required bool isDone,
    required bool isCurrent,
  }) {
    final theme = Theme.of(context).colorScheme;
    final ui = TaskStatusUi.of(context, status);
    final accent = isDone || isCurrent
        ? ui.color
        : theme.onSurface.withValues(alpha: 0.25);

    return SizedBox(
      width: 64.w,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: isDone
                  ? ui.color
                  : (isCurrent ? ui.background : theme.surface),
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: isCurrent ? 2 : 1.2),
            ),
            child: Icon(
              isDone ? Icons.check_rounded : _icons[status],
              size: 19.r,
              color: isDone ? Colors.white : accent,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            ui.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Styles.textStyle11.copyWith(
              color: isDone || isCurrent ? ui.color : theme.onSurfaceVariant,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// The line between two nodes; coloured once the step before it is passed.
  Widget _connector(BuildContext context, {required bool reached}) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      // Vertically centers the line on the 38r node circles.
      padding: EdgeInsets.only(top: 18.r),
      child: Container(
        height: 2.5,
        decoration: BoxDecoration(
          color: reached
              ? theme.primary
              : theme.onSurface.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
