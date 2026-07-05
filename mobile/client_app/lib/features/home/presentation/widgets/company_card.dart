import 'package:client_app/features/companies/domain/entities/company_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/rating_badge.dart';

class CompanyCard extends StatelessWidget {
  final CompanyEntity company;
  final VoidCallback? onTap;

  const CompanyCard({super.key, required this.company, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        // margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
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
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              Positioned(
                top: 12.h,
                right: 12.w,
                child: RatingBadge(rating: company.rating.toString()),
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
                        Icon(
                          Icons.location_on,
                          size: 14.sp,
                          color: Colors.white70,
                        ),
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
      ),
    );
  }
}
