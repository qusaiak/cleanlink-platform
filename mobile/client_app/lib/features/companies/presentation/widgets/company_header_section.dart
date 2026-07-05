import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../domain/entities/company_entity.dart';

class CompanyHeaderSection extends StatelessWidget {
  final CompanyEntity company;

  const CompanyHeaderSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context)!.colorScheme;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 240.h,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const BackButton(),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;

          final opacity = ((240.h - top) / (240.h - kToolbarHeight)).clamp(
            0.0,
            1.0,
          );

          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
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
                          Colors.black.withOpacity(.7),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  right: 20,
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
                Positioned(
                  top: 40.h,
                  right: 20.w,
                  child: BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      bool isFav = company.isFavorite;

                      if (state is FavoritesLoaded) {
                        isFav = state.data.companies.any(
                          (e) => e.id == company.id,
                        );
                      }

                      return Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: theme.onSurface.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,

                          onPressed: () {
                            context.read<FavoritesBloc>().add(
                              ToggleFavoriteEvent(
                                type: 'company',
                                id: company.id,
                              ),
                            );
                          },

                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),

                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_outline,

                              key: ValueKey(isFav),

                              color: isFav ? Colors.red : theme.onSurface,

                              size: isFav ? 30.sp : 25.sp,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ), // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   child: IconButton(
                //     onPressed: () {
                //       context.read<FavoritesBloc>().add(
                //         ToggleFavoriteEvent(
                //           type: 'company',
                //           id: company.id,
                //         ),
                //       );
                //     },
                //     icon: Icon(
                //       company.isFavorite
                //           ? Icons.favorite
                //           : Icons.favorite_outline,
                //       color: company.isFavorite
                //           ? Colors.red
                //           : Colors.black,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
