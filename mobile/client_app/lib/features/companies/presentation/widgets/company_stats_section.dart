import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../domain/entities/company_entity.dart';

class CompanyStatsSection extends StatelessWidget {
  final CompanyEntity company;

  const CompanyStatsSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 2.4,
        children: [
          _StatCard(
            icon: Icons.star_rounded,
            value: company.rating,
            title: "Rating",
          ),
          _StatCard(
            icon: Icons.cleaning_services_rounded,
            value: company.services.length.toString(),
            title: "Services",
          ),
          _StatCard(
            icon: Icons.reviews_rounded,
            value: "150+",
            title: "Reviews",
          ),
          _StatCard(
            icon: Icons.people_alt_rounded,
            value: "2.5K",
            title: "Clients",
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.title,
  });

  final IconData icon;
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.outline.withOpacity(.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: theme.primary,
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.onSurface,
                  ),
                ),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurface.withOpacity(.7),
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