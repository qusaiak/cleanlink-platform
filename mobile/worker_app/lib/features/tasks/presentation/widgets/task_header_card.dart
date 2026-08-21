import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import 'task_status_badge.dart';

class TaskHeaderCard extends StatelessWidget {
  final Task task;

  const TaskHeaderCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 74.r,
              height: 74.r,
              color: colors.primaryContainer,
              child: task.imageUrl.isEmpty
                  ? Icon(
                      Icons.cleaning_services_outlined,
                      color: colors.primary,
                      size: 30.r,
                    )
                  : CachedNetworkImage(
                      imageUrl: task.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Icon(
                        Icons.cleaning_services_outlined,
                        color: colors.primary,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle18.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (task.packageName.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    task.packageName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle12.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l.task_request_number(task.requestNumber),
                      style: Styles.textStyle11.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TaskStatusBadge(status: task.status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
