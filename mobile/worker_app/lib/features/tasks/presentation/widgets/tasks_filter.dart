import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import 'task_status_ui.dart';

/// Section header above the task list: the "Task List" title and a "Filter"
/// button that opens a status-filter bottom sheet. A small dot on the button
/// indicates an active (non-"all") filter.
class TasksSectionHeader extends StatelessWidget {
  final TaskStatus? activeFilter;
  final ValueChanged<TaskStatus?> onFilterSelected;

  const TasksSectionHeader({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            l.tasks_list_title,
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: () => showTaskFilterSheet(
            context,
            current: activeFilter,
            onSelected: onFilterSelected,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 18.r,
                  color: theme.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  l.tasks_filter,
                  style: Styles.textStyle12.copyWith(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (activeFilter != null) ...[
                  SizedBox(width: 4.w),
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Opens a bottom sheet listing "All" + every [TaskStatus] so the worker can
/// filter the list. Calls [onSelected] with the chosen status (null = all).
void showTaskFilterSheet(
  BuildContext context, {
  required TaskStatus? current,
  required ValueChanged<TaskStatus?> onSelected,
}) {
  final theme = Theme.of(context).colorScheme;
  final l = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    backgroundColor: theme.surface,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    builder: (sheetContext) {
      // "All" is represented by null; the rest map 1:1 to TaskStatus.
      final entries = <MapEntry<TaskStatus?, String>>[
        MapEntry(null, l.filter_all),
        for (final s in TaskStatus.values)
          MapEntry(s, TaskStatusUi.of(context, s).label),
      ];

      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l.tasks_filter,
                    style: Styles.textStyle16.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Scrollable so the options never overflow on shorter screens
              // (the sheet only grows to fit its content thanks to shrinkWrap).
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final entry in entries)
                        _filterTile(
                          context: sheetContext,
                          theme: theme,
                          label: entry.value,
                          selected: entry.key == current,
                          color: entry.key == null
                              ? theme.primary
                              : TaskStatusUi.of(context, entry.key!).color,
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            onSelected(entry.key);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _filterTile({
  required BuildContext context,
  required ColorScheme theme,
  required String label,
  required bool selected,
  required Color color,
  required VoidCallback onTap,
}) {
  return ListTile(
    dense: true,
    onTap: onTap,
    leading: Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
    title: Text(
      label,
      style: Styles.textStyle14.copyWith(
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
    ),
    trailing: selected
        ? Icon(Icons.check_rounded, color: theme.primary, size: 20.r)
        : null,
  );
}
