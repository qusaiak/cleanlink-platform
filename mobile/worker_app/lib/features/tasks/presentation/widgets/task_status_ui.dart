import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';

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
          color: AppColor.primaryColorDarker,
          background: AppColor.primarySoft,
        );
      case TaskStatus.onTheWay:
        return TaskStatusUi(
          label: l.task_status_on_the_way,
          color: AppColor.primaryColorDarker,
          background: AppColor.primarySoft,
        );
      case TaskStatus.inProgress:
        return TaskStatusUi(
          label: l.task_status_in_progress,
          color: AppColor.primaryColorDarker,
          background: AppColor.primarySoft,
        );
      case TaskStatus.completed:
        return TaskStatusUi(
          label: l.task_status_completed,
          color: AppColor.successColor,
          background: AppColor.successSoft,
        );
    }
  }
}

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
