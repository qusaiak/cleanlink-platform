import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/content_validation.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../companies/presentation/widgets/reviews_section.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../domain/entities/service_entity.dart';
import 'before_after_gallery.dart';
import 'service_overview_section.dart';
import 'service_packages_section.dart';

class ServiceSummaryCard extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback onAddReview;

  const ServiceSummaryCard({
    super.key,
    required this.service,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final hasCompanyName = ContentValidation.hasText(service.company?.name);
    final hasCompanyLocation = ContentValidation.hasText(
      service.company?.location,
    );
    final hasCompany = hasCompanyName || hasCompanyLocation;
    final hasDuration = service.minDuration > 0 || service.maxDuration > 0;
    final reviews = service.reviews ?? const [];
    final packages = ContentValidation.validItems(
      service.packages,
      (item) => item.id > 0 && ContentValidation.hasText(item.name),
    );
    final images = ContentValidation.validItems(
      service.images,
      (item) =>
          ContentValidation.hasImageUrl(item.imageBefore) ||
          ContentValidation.hasImageUrl(item.imageAfter),
    );
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withValues(alpha: 0.3),
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
                  service.name,
                  maxLines: 2,
                  style: Styles.textStyle18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: onAddReview,
                child: Icon(Icons.rate_review_rounded),
              ),
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  var isFavorite = service.isFavorite;
                  if (state is FavoritesLoaded) {
                    isFavorite = state.data.services.any(
                      (item) => item.id == service.id,
                    );
                  }
                  return IconButton(
                    onPressed: () => context.read<FavoritesBloc>().add(
                      ToggleFavoriteEvent(type: 'service', id: service.id),
                    ),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        key: ValueKey(isFavorite),
                        color: isFavorite ? Colors.red : theme.primary,
                        size: isFavorite ? 30.sp : 25.sp,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (hasCompany) ...[
            if (hasCompanyName)
              Row(
                children: [
                  Icon(Icons.business, size: 14.sp, color: theme.primary),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      service.company!.name.trim(),
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle12.copyWith(color: theme.primary),
                    ),
                  ),
                ],
              ),
            if (hasCompanyLocation)
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14.sp,
                    color: theme.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      service.company!.location.trim(),
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle11.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
          ],
          if (service.rating > 0 || reviews.isNotEmpty || hasDuration) ...[
            SizedBox(height: 16.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = 3;
                final tileWidth = constraints.maxWidth / columns;
                return Wrap(
                  runSpacing: 12.h,
                  children: [
                    if (service.rating > 0)
                      SizedBox(
                        width: tileWidth,
                        child: _InfoTile(
                          icon: Icons.star_rounded,
                          value: service.rating.toString(),
                          label: l.search_rating,
                        ),
                      ),
                    if (reviews.isNotEmpty)
                      SizedBox(
                        width: tileWidth,
                        child: _InfoTile(
                          icon: Icons.reviews_rounded,
                          value: reviews.length.toString(),
                          label: l.reviews,
                        ),
                      ),
                    if (hasDuration)
                      SizedBox(
                        width: tileWidth,
                        child: _InfoTile(
                          icon: Icons.schedule_rounded,
                          value: _durationValue(service),
                          label: l.duration,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          if (ContentValidation.hasText(service.description)) ...[
            SizedBox(height: 16.h),
            ServiceOverviewSection(overview: service.description.trim()),
          ],
          if (packages.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ServicePackagesSection(packages: packages),
          ],
          if (images.isNotEmpty) ...[
            SizedBox(height: 16.h),
            BeforeAfterGallery(images: images),
          ],
          if (reviews.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ReviewsSection(reviews: reviews),
          ],
        ],
      ),
    );
  }
}

String _durationValue(ServiceEntity service) {
  if (service.minDuration <= 0) return service.maxDuration.toString();
  if (service.maxDuration <= 0 || service.minDuration == service.maxDuration) {
    return service.minDuration.toString();
  }
  return '${service.minDuration} - ${service.maxDuration}';
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String label;

  const _InfoTile({required this.icon, this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.sp, color: theme.primary),
        SizedBox(height: 6.h),
        if (value != null)
          Text(
            value!,
            style: Styles.textStyle12.copyWith(fontWeight: FontWeight.bold),
          ),
        Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Styles.textStyle11.copyWith(
            color: theme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
    return child;
  }
}
