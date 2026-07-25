import 'package:client_app/features/services/domain/entities/package_entity.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/row_title.dart';
import '../bloc/services_bloc.dart';

class ServicePackagesSection extends StatefulWidget {
  final List<PackageEntity> packages;
  const ServicePackagesSection({super.key, required this.packages});

  @override
  State<ServicePackagesSection> createState() => _ServicePackagesSectionState();
}

class _ServicePackagesSectionState extends State<ServicePackagesSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if (state is! ServiceDetailsLoaded) {
          return const SizedBox();
        }
        final selectedPackage = state.selectedPackage ?? widget.packages.first;

        final selectedIndex = widget.packages.indexWhere(
          (e) => e.id == selectedPackage.id,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowTitle(
              iconData: Icons.home_work_outlined,
              title: AppLocalizations.of(context)!.choose_package,
              padding: EdgeInsets.all(0),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 5.w,
              runSpacing: 10.h,
              children: List.generate(widget.packages.length, (index) {
                final package = widget.packages[index];

                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    context.read<ServicesBloc>().add(
                      SelectPackageEvent(package),
                    );
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primary : theme.surface,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: isSelected
                            ? theme.primary
                            : theme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      package.name,
                      maxLines: 2,
                      style: Styles.textStyle12.copyWith(
                        color: isSelected ? Colors.white : theme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: theme.outline.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedPackage.name,
                          maxLines: 2,
                          style: Styles.textStyle14.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "${selectedPackage.price} ${AppLocalizations.of(context)!.sp}",
                          style: Styles.textStyle12.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: theme.onSurface.withOpacity(0.7),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${selectedPackage.duration.toString()} ${AppLocalizations.of(context)!.track_minutes_short}",
                        style: Styles.textStyle12.copyWith(
                          color: theme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(height: 1, color: theme.outline.withOpacity(0.2)),
                  SizedBox(height: 16.h),
                  Text(
                    "${AppLocalizations.of(context)!.what_is_included}:",
                    style: Styles.textStyle12.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...selectedPackage.details.map(
                    (feature) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16.sp,
                            color: theme.primary,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              feature,
                              maxLines: 5,
                              style: Styles.textStyle12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
