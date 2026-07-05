import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_app/core/utils/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_theme_info.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../companies/domain/entities/manager_entity.dart';
import '../../../companies/domain/entities/region_entity.dart';
import '../../../home/presentation/widgets/company_card.dart';
import '../../domain/entities/region_company_entity.dart';
import '../../domain/entities/region_details_entity.dart';
import '../bloc/regions_bloc.dart';
import 'region_company_card.dart';

class RegionBody extends StatefulWidget {
  const RegionBody({super.key, required this.id});

  final int id;

  @override
  State<RegionBody> createState() => _RegionBodyState();
}

class _RegionBodyState extends State<RegionBody> {
  @override
  void initState() {
    super.initState();
    context.read<RegionsBloc>().add(GetRegionEvent(widget.id));
  }

  void _retry() => context.read<RegionsBloc>().add(GetRegionEvent(widget.id));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context)!.colorScheme;
    return BlocBuilder<RegionsBloc, RegionsState>(
      buildWhen: (_, current) =>
          current is RegionLoading ||
          current is RegionLoaded ||
          current is RegionError,
      builder: (context, state) {
        if (state is RegionError) {
          return _ErrorView(message: state.message, onRetry: _retry);
        }

        final isLoading = state is! RegionLoaded;
        final region = state is RegionLoaded ? state.region : _skeleton;
        if (isLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: _RegionContent(region: region, isLoading: isLoading),
        );
      },
    );
  }
}

final _skeleton = RegionDetailsEntity(
  id: 0,
  name: 'Region name',
  image: Assets.images.test.test.path,
  manager: ManagerEntity(
    id: 3,
    fullname: "Sara Region Manager",
    email: "sara.rm@cleaning.com",
    role: "region_manager",
  ),
  companies: List.generate(
    4,
    (i) => CompanyEntity(
      id: 3,
      managerId: 30,
      regionId: 3,
      name: "CleanMaster",
      description: "Complete cleaning solutions",
      image: Assets.images.test.test.path,
      location: "Homs",
      rating: 4,
      isOpen: true,
      isFavorite: false,
      startHour: "10:00:00",
      closeHour: "20:00:00",
      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        name: "Aleppo",
        image: Assets.images.test.test.path,
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],
      workers: [],
      reviews: [],

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ),
);

class _RegionContent extends StatelessWidget {
  const _RegionContent({required this.region, required this.isLoading});

  final RegionDetailsEntity region;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200.h,
          backgroundColor: AppThemeInfo.isLight
              ? AppColor.backgroundColorLight
              : AppColor.backgroundColorDark,
          shadowColor: AppColor.transparent,
          foregroundColor: AppColor.transparent,
          surfaceTintColor: AppColor.transparent,
          flexibleSpace: FlexibleSpaceBar(
            // titlePadding: EdgeInsets.symmetric(
            //   horizontal: 56.w,
            //   vertical: 14.h,
            // ),
            title: Text(
              region.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.textStyle16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                CustomImageView(
                  imagePath: region.image!,
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (region.manager != null) _ManagerTile(region: region),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.business_rounded,
                        value: "${region.totalCompanies}",
                        label: l.total_companies,
                        color: theme.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_rounded,
                        value: "${region.openCompanies}",
                        label: l.open_companies,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (region.companies.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 48.sp,
                    color: theme.onSurfaceVariant,
                  ),
                  SizedBox(height: 12.h),
                  Text(l.no_companies_found, textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 16.h),
            sliver: SliverList.separated(
              itemCount: region.companies.length,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (_, index) {
                final company = region.companies[index];
                return SizedBox(
                  height: 200.w,
                  child: CompanyCard(
                    company: company,
                    onTap: isLoading
                        ? null
                        : () => GoRouter.of(
                            context,
                          ).push(AppRouter.kCompanyDetails, extra: company.id),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ManagerTile extends StatelessWidget {
  const _ManagerTile({required this.region});

  final RegionDetailsEntity region;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final manager = region.manager!;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: theme.primary.withValues(alpha: 0.12),
            child: Icon(Icons.person_rounded, color: theme.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.manager_label,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  manager.fullname,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  manager.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurfaceVariant,
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Styles.textStyle22.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Styles.textStyle11.copyWith(color: theme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 42.sp),
            SizedBox(height: 10.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}
