import 'package:client_app/core/utils/gen/assets.gen.dart';
import 'package:client_app/features/bookings/presentation/widgets/booking_info_chip.dart';
import 'package:client_app/features/bookings/presentation/widgets/booking_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';

import '../../../../core/widgets/custom_image_view.dart';
import '../../domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingCard({super.key, required this.booking});

  Color _statusColor() {
    switch (booking.status.toLowerCase()) {
      case 'ongoing':
        return AppColor.primaryColor;

      case 'upcoming':
        return AppColor.secondaryColor;

      case 'completed':
        return AppColor.success;

      case 'cancelled':
        return AppColor.error;

      default:
        return AppColor.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final accent = _statusColor();
    final glassColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(.05)
        : Colors.white.withOpacity(.55);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),

        child: Container(
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: accent),
            boxShadow: [
              BoxShadow(
                blurRadius: 26,

                offset: const Offset(0, 10),

                color: theme.shadow.withOpacity(.08),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 10.w,

                  decoration: BoxDecoration(
                    color: accent,

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),

                      bottomLeft: Radius.circular(20.r),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(18.r),

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
                                    booking.serviceName,

                                    style: Styles.textStyle16.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  Text(
                                    booking.companyName,

                                    style: Styles.textStyle12.copyWith(
                                      color: theme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BookingStatusBadge(
                              status: booking.status.toUpperCase(),
                              color: accent,
                            ),
                          ],
                        ),

                        SizedBox(height: 18.h),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),

                          decoration: BoxDecoration(
                            color: AppColor.transparent,

                            borderRadius: BorderRadius.circular(20.r),
                          ),

                          child: Row(
                            children: [
                              // Display person placeholder image if it doesn't assigned to any worker yet or if the worker doesn't have an image
                              CustomImageView(
                                imagePath: booking.worker?.name[0] != null
                                    ? Assets.images.test.worker.path
                                    : Assets
                                          .images
                                          .placeholders
                                          .personPlaceholder
                                          .path,
                                width: 50,
                                height: 50,
                                radius: BorderRadius.all(Radius.circular(50.r)),
                                fit: BoxFit.cover,
                              ),

                              SizedBox(width: 14.w),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      booking.worker?.name ?? "No worker",

                                      style: Styles.textStyle14,
                                    ),

                                    SizedBox(height: 4.h),

                                    Text(
                                      "Assigned Cleaner",

                                      style: Styles.textStyle12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        Wrap(
                          spacing: 8.w,

                          children: [
                            BookingInfoChip(
                              icon: Icons.calendar_month_outlined,
                              text: "Today",
                            ),

                            BookingInfoChip(
                              icon: Icons.schedule_outlined,
                              text: booking.time,
                            ),
                          ],
                        ),

                        SizedBox(height: 18.h),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BookingInfoChip(
                              icon: Icons.payments_outlined,
                              text: "${booking.price} \$",
                            ),
                            const Spacer(),
                            (booking.status.toLowerCase() == "ongoing" ||
                                    booking.status.toLowerCase() == "upcoming")
                                ? FilledButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        theme.primary,
                                      ),
                                    ),
                                    icon: const Icon(Icons.route_rounded),

                                    label: const Text("Track"),
                              onPressed: () {
                                      GoRouter.of(context).push(
                                        AppRouter.kTrackService,
                                        extra: booking.id,
                                      );
                              },
                            )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
