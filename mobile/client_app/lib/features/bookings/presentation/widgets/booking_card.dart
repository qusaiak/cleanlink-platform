import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/booking_entity.dart';
import 'booking_info_chip.dart';
import 'booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  final OrderEntity booking;
  const BookingCard({super.key, required this.booking});
  Color _statusColor() {
    switch (booking.statusType) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.assignedToWorker:
        return AppColor.primaryColor;
      case OrderStatus.inProgress:
        return Colors.purple;
      case OrderStatus.completed:
        return AppColor.success;
      case OrderStatus.canceled:
        return AppColor.error;
      case OrderStatus.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final accent = _statusColor();
    final package = booking.package;
    final service = package?.service;
    final company = service?.company;
    final date = booking.startTime == null
        ? '—'
        : DateFormat(
            'MMM d, y - h:mm a',
            Localizations.localeOf(context).languageCode,
          ).format(booking.startTime!.toLocal());
    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () => context.push(AppRouter.orderDetailsPath(booking.id)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: accent.withValues(alpha: .45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service?.name ??
                              package?.name ??
                              AppLocalizations.of(context)!.service_details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle14.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (package?.name.isNotEmpty == true)
                          Text(
                            package!.name,
                            style: Styles.textStyle12.copyWith(
                              color: theme.onSurfaceVariant,
                            ),
                          ),
                        // if (company?.name.isNotEmpty == true)
                        //   Text(
                        //     company!.name,
                        //     style: Styles.textStyle12.copyWith(
                        //       color: theme.onSurfaceVariant,
                        //     ),
                        //   ),
                        // if (booking.leader?.fullname.isNotEmpty == true &&
                        //     (booking.isAssigned || booking.isInProgress))
                        //   Text(
                        //     '${AppLocalizations.of(context)!.team_leader}: ${booking.leader!.fullname}',
                        //     style: Styles.textStyle12.copyWith(
                        //       color: theme.onSurfaceVariant,
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                  BookingStatusBadge(status: booking.status, color: accent),
                ],
              ),
              SizedBox(height: 12.h),
              BookingInfoChip(icon: Icons.calendar_month_outlined, text: date),
              BookingInfoChip(
                icon: Icons.location_on_outlined,
                text: booking.location,
              ),
              Row(
                children: [
                  Expanded(
                    child: BookingInfoChip(
                      icon: Icons.schedule_outlined,
                      text:
                          '${booking.duration} ${AppLocalizations.of(context)!.minutes}',
                    ),
                  ),
                  BookingInfoChip(
                    icon: Icons.payments_outlined,
                    text:
                        '${booking.totalPrice.toStringAsFixed(2)} ${AppLocalizations.of(context)!.sp}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
