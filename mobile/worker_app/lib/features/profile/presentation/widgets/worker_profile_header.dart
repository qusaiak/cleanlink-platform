import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../domain/entities/worker_profile.dart';
import 'worker_availability_ui.dart';
import 'worker_status_badge.dart';

/// Avatar (with verified badge), name and role at the top of the profile.
class WorkerProfileHeader extends StatelessWidget {
  final WorkerProfile profile;

  const WorkerProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    // The avatar ring reflects the worker's current availability colour.
    final ringColor = WorkerAvailabilityUi.of(context, profile.availability).color;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 3),
              ),
              child: CircleAvatar(
                radius: 48.r,
                backgroundColor: theme.primary.withValues(alpha: 0.1),
                backgroundImage: profile.avatarUrl.isNotEmpty
                    ? NetworkImage(profile.avatarUrl)
                    : null,
                child: profile.avatarUrl.isEmpty
                    ? Icon(Icons.person, size: 40.r, color: theme.primary)
                    : null,
              ),
            ),
            if (profile.isVerified)
              PositionedDirectional(
                end: 4.w,
                bottom: 2.h,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    color: AppColor.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.surface, width: 2),
                  ),
                  child: Icon(Icons.check_rounded, size: 14.r, color: Colors.white),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        // Name with the live availability status beside it.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                profile.name,
                style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8.w),
            WorkerStatusBadge(availability: profile.availability),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          profile.role,
          style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
        ),
      ],
    );
  }
}
