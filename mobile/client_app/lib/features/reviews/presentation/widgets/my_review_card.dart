import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/helper_functions.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/my_review_entity.dart';

class MyReviewCard extends StatelessWidget {
  final MyReviewEntity review;
  final VoidCallback? onTap;

  const MyReviewCard({super.key, required this.review, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final item = review.service ?? review.company;
    final name = review.service?.name ?? review.company?.name ?? '';
    final image = review.service?.image ?? review.company?.image ?? '';
    final detail = review.service != null
        ? formatServicePriceRange(context, review.service!)
        : review.company?.location ?? '';
    final date = review.createdAt == null
        ? ''
        : MaterialLocalizations.of(
            context,
          ).formatShortDate(review.createdAt!.toLocal());

    return Card(
      key: ValueKey(review.id),
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: item == null ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: image.isEmpty
                    ? Icon(
                        Icons.image_not_supported_outlined,
                        color: colors.onSurfaceVariant,
                      )
                    : CustomImageView(
                        imagePath: image,
                        width: 76.w,
                        height: 76.w,
                        fit: BoxFit.cover,
                        radius: BorderRadius.circular(12.r),
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${l.your_rating}: ${review.rating}/5',
                          style: Styles.textStyle12.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      review.comment ?? l.no_comment,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle12.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (detail.isNotEmpty || date.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          if (date.isNotEmpty)
                            Expanded(
                              child: Text(
                                '${l.reviewed_on} $date',
                                style: Styles.textStyle11.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          if (detail.isNotEmpty)
                            Text(
                              detail,
                              style: Styles.textStyle11.copyWith(
                                color: colors.primary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
