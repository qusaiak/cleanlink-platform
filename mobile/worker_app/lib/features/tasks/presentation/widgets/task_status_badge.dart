import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../domain/entities/task.dart';
import 'task_status_ui.dart';

class TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;

  const TaskStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final ui = TaskStatusUi.of(context, status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: ui.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        ui.label,
        style: Styles.textStyle11.copyWith(
          color: ui.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
