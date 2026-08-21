import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';

class TaskLocationBanner extends StatelessWidget {
  const TaskLocationBanner({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(18.w),
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
            l.task_location_section,
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: colors.primary,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.location,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle14.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: task.latitude == null || task.longitude == null
                  ? null
                  : () => context.push(AppRouter.kTaskMap, extra: task),
              icon: const Icon(Icons.map_outlined),
              label: Text(l.task_view_map),
            ),
          ),
        ],
      ),
    );
  }
}
