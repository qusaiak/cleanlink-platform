import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/track_service_entity.dart';

class ServiceDetailsCard extends StatelessWidget {
  final TrackServiceEntity tracking;

  const ServiceDetailsCard({super.key, required this.tracking});

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.outlineVariant.withOpacity(.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.service_details,
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 14.h),
          _DetailRow(
            icon: Icons.cleaning_services_outlined,
            label: l.detail_service,
            value: tracking.serviceName,
          ),
          _DetailRow(
            icon: Icons.calendar_month_outlined,
            label: l.detail_date,
            value: _formatDate(tracking.date),
          ),
          _DetailRow(
            icon: Icons.schedule_outlined,
            label: l.detail_time,
            value: tracking.time,
          ),
          _DetailRow(
            icon: Icons.timelapse_outlined,
            label: l.detail_duration,
            value: tracking.duration,
          ),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: l.detail_address,
            value: tracking.address,
          ),
          _DetailRow(
            icon: Icons.payments_outlined,
            label: l.detail_payment,
            value: tracking.paymentMethod,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.sp, color: theme.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: FontWeight.w600,
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
