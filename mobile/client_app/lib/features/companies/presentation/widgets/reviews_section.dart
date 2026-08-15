import 'dart:ui';
import 'package:client_app/features/companies/domain/entities/review_entity.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/helper_functions.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../../../core/widgets/row_title.dart';

class ReviewsSection extends StatelessWidget {
  final List<ReviewEntity> reviews;

  const ReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        RowTitle(
          iconData: Icons.reviews_outlined,
          title: AppLocalizations.of(context)!.customer_reviews,
          padding: EdgeInsets.all(0),
        ),

        SizedBox(height: 12.h),

        Column(
          children: List.generate(reviews.length, (index) {
            final review = reviews[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: GlassReviewCard(
                name: review.client.fullname,
                review: review.comment,
                rating: review.rating.toString(),
                date: DateHelper.formatDate(review.createdAt),
                image: review.client.profile?.image,
                isTopReview: index == 0,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class GlassReviewCard extends StatelessWidget {
  const GlassReviewCard({
    super.key,
    required this.name,
    required this.review,
    required this.rating,
    required this.date,
    this.image,
    this.isTopReview = false,
  });

  final String name;
  final String review;
  final String rating;
  final String date;
  final String? image;
  final bool isTopReview;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black54,
          builder: (_) => ReviewBubbleDialog(
            name: name,
            review: review,
            rating: rating,
            date: date,
            image: image,
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: theme.surfaceContainer,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.5.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .25),
                              ),
                              child: CircleAvatar(
                                radius: 26.r,
                                backgroundImage: (image == "" || image == null)
                                    ? AssetImage(
                                        Assets
                                            .images
                                            .placeholders
                                            .personPlaceholder
                                            .path,
                                      )
                                    : NetworkImage(image!),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 14.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: Styles.textStyle12.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  RatingBadge(rating: rating),
                                ],
                              ),

                              Text(
                                date,
                                style: Styles.textStyle11.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                              ),

                              SizedBox(height: 10.h),

                              Text(
                                review,
                                style: Styles.textStyle12.copyWith(height: 1.6),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewBubbleDialog extends StatelessWidget {
  const ReviewBubbleDialog({
    super.key,
    required this.name,
    required this.review,
    required this.rating,
    required this.date,
    this.image,
  });

  final String name;
  final String review;
  final String rating;
  final String date;
  final String? image;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: CustomPaint(
        child: Container(
          color: theme.surface,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 42.h),
          child: Stack(
            children: [
              Positioned(
                top: 70,
                right: -1,
                child: Icon(
                  Icons.format_quote_rounded,
                  size: 25.sp,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.5.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: .25),
                            ),
                            child: CircleAvatar(
                              radius: 26.r,
                              backgroundImage: (image == "" || image == null)
                                  ? AssetImage(
                                      Assets
                                          .images
                                          .placeholders
                                          .personPlaceholder
                                          .path,
                                    )
                                  : NetworkImage(image!),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Styles.textStyle12.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              date,
                              style: Styles.textStyle11.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      RatingBadge(rating: rating),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  SizedBox(height: 18.h),

                  Text(
                    review,
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    style: Styles.textStyle12.copyWith(color: theme.onSurface),
                  ),
                  SizedBox(height: 24.h),

                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.close,
                        style: Styles.textStyle12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
