import 'dart:ui';

import 'package:client_app/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../../../core/widgets/row_title.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        "name": "Michael Ross",
        "review":
            "Excellent service and professional team. The cleaning quality exceeded my expectations.",
        "rating": 5.0,
        "date": "2 days ago",
      },
      {
        "name": "Sarah Ahmed",
        "review":
            "Very friendly staff and quick booking process. Highly recommended.",
        "rating": 4.8,
        "date": "1 week ago",
      },
      {
        "name": "John Carter",
        "review":
            "The team arrived on time and did a fantastic job. Everything was completed professionally and on schedule.",
        "rating": 5.0,
        "date": "2 weeks ago",
      },
    ];

    return Column(
      children: [
        RowTitle(
          iconData: Icons.reviews_outlined,
          title: "Customer Reviews",
          onTap: () {},
        ),

        SizedBox(height: 12.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: List.generate(reviews.length, (index) {
              final review = reviews[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: GlassReviewCard(
                  name: review["name"] as String,
                  review: review["review"] as String,
                  rating: review["rating"] as double,
                  date: review["date"] as String,
                  isTopReview: index == 0,
                ),
              );
            }),
          ),
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
    this.isTopReview = false,
  });

  final String name;
  final String review;
  final double rating;
  final String date;
  final bool isTopReview;

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white.withOpacity(.08),
                  border: Border.all(color: Colors.white.withOpacity(.25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
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
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.shade300,
                                    Colors.orange.shade400,
                                  ],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 26.r,
                                backgroundImage: AssetImage(
                                  Assets.images.test.worker.path,
                                ),
                              ),
                            ),

                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 16.w,
                                height: 16.w,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 9.sp,
                                ),
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
  });

  final String name;
  final String review;
  final double rating;
  final String date;

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
                  color: Colors.grey.withOpacity(0.5),
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
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade300,
                                  Colors.orange.shade400,
                                ],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26.r,
                              backgroundImage: AssetImage(
                                Assets.images.test.worker.path,
                              ),
                            ),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 16.w,
                              height: 16.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 9.sp,
                              ),
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
                        "Close",
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
