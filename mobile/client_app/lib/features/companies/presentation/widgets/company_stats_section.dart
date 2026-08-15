import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/company_entity.dart';

class CompanyStatsSection extends StatelessWidget {
  final CompanyEntity company;
  final VoidCallback onAddReview;

  const CompanyStatsSection({
    super.key,
    required this.company,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
            value: company.rating.toString(),
            title: l.search_rating,
          ),
          _StatCard(
            icon: Icons.cleaning_services_rounded,
            value: company.services.length.toString(),
            title: l.services_title,
          ),
          _StatCard(
            icon: Icons.reviews_rounded,
            value: company.reviews.length.toString(),
            title: l.reviews,
          ),
          _ActionCard(
            icon: Icons.rate_review_rounded,
            title: l.add_review,
            onTap: onAddReview,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: _cardDecoration(theme),
      child: Row(
        children: [
          _CardIcon(icon: icon),
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
                    color: theme.onSurface.withValues(alpha: .7),
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

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Material(
      color: theme.surfaceContainer,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: _cardDecoration(theme, includeColor: false),
          child: Row(
            children: [
              _CardIcon(icon: icon),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardIcon extends StatelessWidget {
  final IconData icon;

  const _CardIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(icon, size: 18.sp, color: theme.primary),
    );
  }
}

BoxDecoration _cardDecoration(ColorScheme theme, {bool includeColor = true}) =>
    BoxDecoration(
      color: includeColor ? theme.surfaceContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: theme.outline.withValues(alpha: .1)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
