import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/service_status.dart';
import '../utils/track_service_l10n.dart';

class EtaCard extends StatelessWidget {
  final ServiceStatus status;
  final int etaMinutes;

  const EtaCard({super.key, required this.status, required this.etaMinutes});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
    final accent = status.color;

    final etaText = status == ServiceStatus.completed
        ? l.status_completed
        : "$etaMinutes ${l.track_minutes_short}";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withOpacity(.14), accent.withOpacity(.04)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: accent.withOpacity(.30)),
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: accent.withOpacity(.16),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.timelapse_rounded, color: accent, size: 26.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.track_estimated_arrival,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  etaText,
                  style: Styles.textStyle20.copyWith(
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  status.message(context),
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
