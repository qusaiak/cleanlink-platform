import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../domain/entities/company_entity.dart';

class CompanyHeaderSection extends StatelessWidget {
  final CompanyEntity company;

  const CompanyHeaderSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
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
                company.nameEn,
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
                        company.nameEn,
                        style: Styles.textStyle18.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${company.region.nameEn} | ${company.locationEn}",
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
