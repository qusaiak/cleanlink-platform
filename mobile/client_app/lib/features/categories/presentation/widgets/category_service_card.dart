import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/helper_functions.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../services/domain/entities/service_entity.dart';

class CategoryServiceCard extends StatelessWidget {
  const CategoryServiceCard({super.key, required this.service, this.onTap});

  final ServiceEntity service;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: theme.surface,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              _buildImage(theme),
              SizedBox(width: 12.w),
              Expanded(child: _buildInfo(context, theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme theme) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CustomImageView(
            imagePath: service.image,
            width: 92.w,
            height: 92.w,
            fit: BoxFit.cover,
          ),
        ),
        if (service.discount != 0.00)
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "-${service.discount.toInt()}%",
                style: Styles.textStyle8.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context, ColorScheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          service.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4.h),
        Text(
          service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Styles.textStyle11.copyWith(color: theme.onSurfaceVariant),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 16.sp, color: Colors.amber),
            SizedBox(width: 2.w),
            Text(
              service.rating.toString(),
              style: Styles.textStyle11.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 12.w),
            Icon(
              Icons.schedule_rounded,
              size: 15.sp,
              color: theme.onSurfaceVariant,
            ),
            SizedBox(width: 3.w),
            Text(
              "${service.minDuration}-${service.maxDuration}",
              style: Styles.textStyle11.copyWith(color: theme.onSurfaceVariant),
            ),
            const Spacer(),
            Text(
              formatServicePriceRange(context, service),
              style: Styles.textStyle12.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
