import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../data/models/company_model.dart';

class CompanyCard extends StatelessWidget {
  final CompanyModel company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: theme.surfaceContainer,
        borderRadius: AppRadius.card,
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: Stack(
          children: [
            CustomImageView(
              imagePath: company.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Positioned(
              top: 12.h,
              right: 12.w,
              child: RatingBadge(rating: company.rating),
            ),

            Positioned(
              left: 14.w,
              right: 14.w,
              bottom: 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14.sp, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          company.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
