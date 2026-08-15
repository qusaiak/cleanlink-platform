import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/glass/circular_glass_button.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../domain/entities/company_entity.dart';

class CompanyHeaderSection extends StatelessWidget {
  final CompanyEntity company;

  const CompanyHeaderSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 240.h,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const BackButton(),
      actions: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            var isFav = company.isFavorite;
            if (state is FavoritesLoaded) {
              isFav = state.data.companies.any((item) => item.id == company.id);
            }
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 12.w),
              child: CircularGlassButton(
                onTap: () => context.read<FavoritesBloc>().add(
                  ToggleFavoriteEvent(type: 'company', id: company.id),
                ),
                icon: isFav ? Icons.favorite : Icons.favorite_outline,
                isActive: isFav,
                activeColor: theme.error,
              ),
            );
          },
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;

          final opacity = ((240.h - top) / (240.h - kToolbarHeight)).clamp(
            0.0,
            1.0,
          );

          return FlexibleSpaceBar(
            titlePadding: EdgeInsetsDirectional.only(
              start: 56.w,
              end: 56.w,
              bottom: 16.h,
            ),
            title: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: opacity),
              duration: const Duration(milliseconds: 150),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 15 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Text(
                company.name,
                style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            background: Stack(
              children: [
                Positioned.fill(
                  child: CustomImageView(
                    imagePath: company.image,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .7),
                        ],
                      ),
                    ),
                  ),
                ),

                PositionedDirectional(
                  start: 20.w,
                  end: 20.w,
                  bottom: 20,
                  child: Column(
                    children: [
                      Text(
                        company.name,
                        style: Styles.textStyle18.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${company.region.name} | ${company.location}",
                        style: Styles.textStyle12.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
