import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/row_title.dart';
import '../../domain/entities/company_entity.dart';

class WorkingHoursSection extends StatelessWidget {
  final CompanyEntity company;

  const WorkingHoursSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        RowTitle(
          iconData: Icons.access_time_rounded,
          title: AppLocalizations.of(context)!.working_hours,
        ),

        SizedBox(height: 12.h),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: theme.outline.withOpacity(.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Text(
                    AppLocalizations.of(context)!.open_now,
                    style: Styles.textStyle12.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "Closes 8:00 PM",
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurface,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              _WorkingHourItem(
                day: "Monday - Friday",
                time: "08:00 AM - 08:00 PM",
              ),

              SizedBox(height: 8.h),

              const _WorkingHourItem(
                day: "Saturday",
                time: "09:00 AM - 05:00 PM",
              ),

              SizedBox(height: 8.h),

              const _WorkingHourItem(
                day: "Sunday",
                time: "Closed",
                isClosed: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkingHourItem extends StatelessWidget {
  const _WorkingHourItem({
    required this.day,
    required this.time,
    this.isClosed = false,
  });

  final String day;
  final String time;
  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color:  Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  day,
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),

          Text(
            time,
            style: Styles.textStyle12.copyWith(
              fontWeight: FontWeight.w500,
              color: isClosed
                  ? Colors.redAccent
                  : theme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

