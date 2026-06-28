import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:client_app/features/services/presentation/widgets/service_overview_section.dart';
import 'package:client_app/features/services/presentation/widgets/service_packages_section.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../companies/presentation/widgets/reviews_section.dart';
import 'before_after_gallery.dart';

class ServiceSummaryCard extends StatelessWidget {
  final ServiceEntity service;
  const ServiceSummaryCard({super.key, required this.service});
  // final List<ServicePackage> packages = [
  //   ServicePackage(
  //     name: "Studio",
  //     price: 75,
  //     duration: "2 hours",
  //     features: [
  //       "Dusting all surfaces",
  //       "Vacuuming floors",
  //       "Mopping",
  //       "Bathroom cleaning",
  //       "Kitchen wipe-down",
  //     ],
  //   ),
  //   ServicePackage(
  //     name: "2 Bedroom",
  //     price: 95,
  //     duration: "2.5 hours",
  //     features: [
  //       "Everything in Studio",
  //       "All bedrooms included",
  //       "Closet organization",
  //       "Window sill cleaning",
  //     ],
  //   ),
  //   ServicePackage(
  //     name: "3 Bedroom",
  //     price: 115,
  //     duration: "3 hours",
  //     features: [
  //       "Everything in 2BR",
  //       "Deep bathroom scrub",
  //       "Appliance exterior",
  //       "Baseboard dusting",
  //     ],
  //   ),
  //   ServicePackage(
  //     name: "Villa",
  //     price: 150,
  //     duration: "4+ hours",
  //     features: [
  //       "Full house cleaning",
  //       "Outdoor patio sweep",
  //       "Garage floor clean",
  //       "Premium eco‑products",
  //     ],
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service.nameEn,
                  maxLines: 2,
                  style: Styles.textStyle18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Top rated",
                  style: Styles.textStyle11.copyWith(color: theme.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.business, size: 14.sp, color: theme.primary),
              SizedBox(width: 4.w),
              Text(
                service.company!.nameEn,
                style: Styles.textStyle12.copyWith(color: theme.primary),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14,
                color: theme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                service.company!.locationEn,
                style: Styles.textStyle11.copyWith(
                  color: theme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.star_rounded,
                  value: service.rating,
                  label: "Rating",
                ),
              ),
              Expanded(
                child: _InfoTile(
                  icon: Icons.reviews_rounded,
                  value: service.reviews!.length.toString(),
                  label: "Reviews",
                ),
              ),
              Expanded(
                child: _InfoTile(
                  icon: Icons.schedule_rounded,
                  value: "${service.minDuration} - ${service.maxDuration}",
                  label: "Duration",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ServiceOverviewSection(overview: service.descriptionEn),
          SizedBox(height: 16.h),
          ServicePackagesSection(packages: service.packages!),
          SizedBox(height: 16.h),
          BeforeAfterGallery(),
          SizedBox(height: 16.h),
          ReviewsSection(company: service.company!),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _InfoTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: theme.primary),
        SizedBox(height: 6.h),
        Text(
          value,
          style: Styles.textStyle12.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Styles.textStyle11.copyWith(
            color: theme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
