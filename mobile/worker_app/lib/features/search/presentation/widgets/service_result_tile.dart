import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/presentation/utils/task_formatting.dart';
import '../../domain/entities/service_summary.dart';

/// A single search result card: service name + client, with location and time
/// meta rows.
class ServiceResultTile extends StatelessWidget {
  final ServiceSummary service;
  final VoidCallback? onTap;

  const ServiceResultTile({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cleaning_services_rounded,
                        color: theme.primary,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.serviceName,
                            style: Styles.textStyle14.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            service.clientName,
                            style: Styles.textStyle12.copyWith(
                              color: theme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (service.price != null)
                      Text(
                        l.price_amount(service.price!.toStringAsFixed(0)),
                        style: Styles.textStyle14.copyWith(
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                _meta(theme, Icons.location_on_rounded, service.location),
                SizedBox(height: 4.h),
                _meta(
                  theme,
                  Icons.schedule_rounded,
                  '${formatTaskDate(service.scheduledAt, localeCode)} · '
                  '${formatTaskTime(service.scheduledAt)}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _meta(ColorScheme theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.r, color: theme.onSurfaceVariant),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
