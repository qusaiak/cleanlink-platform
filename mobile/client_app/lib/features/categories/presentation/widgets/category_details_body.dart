import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/app_theme_info.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/categories_bloc.dart';
import 'category_service_card.dart';

class CategoryDetailsBody extends StatefulWidget {
  const CategoryDetailsBody({super.key, required this.id});

  final int id;

  @override
  State<CategoryDetailsBody> createState() => _CategoryDetailsBodyState();
}

class _CategoryDetailsBodyState extends State<CategoryDetailsBody> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(GetCategoryEvent(widget.id));
  }

  void _retry() =>
      context.read<CategoriesBloc>().add(GetCategoryEvent(widget.id));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      buildWhen: (_, current) =>
          current is CategoryLoading ||
          current is CategoryLoaded ||
          current is CategoryError,
      builder: (context, state) {
        if (state is CategoryError) {
          return _ErrorView(message: state.message, onRetry: _retry);
        }

        final isLoading = state is! CategoryLoaded;
        final category = state is CategoryLoaded ? state.category : _skeleton;
        if (isLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: _CategoryContent(category: category),
        );
      },
    );
  }
}

/// Placeholder data shown while [Skeletonizer] is active.
final _skeleton = CategoryEntity(
  id: 0,
  name: 'Category name',
  description: 'A short description of this category goes right here.',
  image: '',
  services: List.generate(
    4,
    (i) => ServiceEntity(
      id: 4,
      companyId: 1,
      categoryId: 3,
      name: "Car Wash",
      description: "Interior & exterior cleaning",
      rating: 4.6,
      minDuration: 30,
      maxDuration: 60,
      price: 18,
      image: Assets.images.test.test.path,
      discount: 15,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ),
);

class _CategoryContent extends StatelessWidget {
  const _CategoryContent({required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 260.h,
          pinned: true,
          backgroundColor: AppThemeInfo.isLight
              ? AppColor.backgroundColorLight
              : AppColor.backgroundColorDark,
          shadowColor: AppColor.transparent,
          foregroundColor: AppColor.transparent,
          surfaceTintColor: AppColor.transparent,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Styles.textStyle16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                CustomImageView(imagePath: category.image, fit: BoxFit.cover),
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
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   category.name,
                //   style: Styles.textStyle22.copyWith(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                RowTitle(
                  iconData: Icons.description_outlined,
                  title: AppLocalizations.of(context)!.overview,
                  padding: EdgeInsets.all(0),
                ),
                SizedBox(height: 8.h),
                Text(
                  category.description,
                  maxLines: 10,
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    RowTitle(
                      iconData: Icons.cleaning_services_outlined,
                      title: AppLocalizations.of(context)!.services_title,
                      padding: EdgeInsets.all(0),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${category.serviceCount}",
                        style: Styles.textStyle12.copyWith(
                          color: theme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
        if (category.services.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppEmptyState(
                icon: Icons.inbox_outlined,
                title: l.no_services_available,
                iconColor: theme.onSurfaceVariant,
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            sliver: SliverList.separated(
              itemCount: category.services.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (_, index) => CategoryServiceCard(
                service: category.services[index],
                onTap: () {
                  GoRouter.of(context).push(
                    AppRouter.kServiceDetails,
                    extra: category.services[index].id,
                  );
                },
              ),
            ),
          ),
      ],
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
