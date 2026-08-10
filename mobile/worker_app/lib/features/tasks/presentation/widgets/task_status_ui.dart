import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';

/// Presentation metadata for a [TaskStatus]: a localized [label] plus the
/// accent [color] and [background] used by the status badge.
///
/// This lives in the presentation layer (not the domain) so the entity stays
/// framework-free. All colours come from the project palette ([AppColor]) —
/// the teal/green/amber identity — NOT the blues from the design mockups.
class TaskStatusUi {
  final String label;
  final Color color;
  final Color background;

  const TaskStatusUi({
    required this.label,
    required this.color,
    required this.background,
  });

  factory TaskStatusUi.of(BuildContext context, TaskStatus status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case TaskStatus.assigned:
        return TaskStatusUi(
          label: l.task_status_assigned,
          color: AppColor.secondaryColorDark,
          background: AppColor.secondarySoft,
        );
      case TaskStatus.onTheWay:
        // Distinct from "assigned" via the neutral info tone, so the two
        // pre-work states remain visually separable at a glance.
        return TaskStatusUi(
          label: l.task_status_on_the_way,
          color: AppColor.infoColor,
          background: AppColor.infoSoft,
        );
      case TaskStatus.inProgress:
        return TaskStatusUi(
          label: l.task_status_in_progress,
          color: AppColor.primaryColorDarker,
          background: AppColor.primarySoft,
        );
      case TaskStatus.paused:
        return TaskStatusUi(
          label: l.task_status_paused,
          color: AppColor.warningColor,
          background: AppColor.warningSoft,
        );
      case TaskStatus.completed:
        return TaskStatusUi(
          label: l.task_status_completed,
          color: AppColor.successColor,
          background: AppColor.successSoft,
        );
      case TaskStatus.cancelled:
        return TaskStatusUi(
          label: l.task_status_cancelled,
          color: AppColor.errorLight,
          background: AppColor.errorSoft,
        );
    }
  }
}

/// Icon used to represent a [ServiceType] in cards and the detail header.
IconData serviceTypeIcon(ServiceType type) {
  switch (type) {
    case ServiceType.acMaintenance:
      return Icons.ac_unit_rounded;
    case ServiceType.plumbing:
      return Icons.plumbing_rounded;
    case ServiceType.electrical:
      return Icons.bolt_rounded;
    case ServiceType.cleaning:
      return Icons.cleaning_services_rounded;
    case ServiceType.general:
      return Icons.handyman_rounded;
  }
}
