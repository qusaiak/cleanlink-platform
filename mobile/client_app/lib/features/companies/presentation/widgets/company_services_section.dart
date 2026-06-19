import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../home/data/models/service_model.dart';
import '../../../home/presentation/widgets/service_tile.dart';

class CompanyServicesSection extends StatelessWidget {
  const CompanyServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      ServiceModel(
        title: "House Cleaning",
        company: "Sparkle Clean",
        duration: "2 Hours",
        price: "\$25",
        image: Assets.images.test.test.path,
      ),
      ServiceModel(
        title: "Deep Cleaning",
        company: "Sparkle Clean",
        duration: "4 Hours",
        price: "\$60",
        image: Assets.images.test.test.path,
      ),
      ServiceModel(
        title: "Sofa Cleaning",
        company: "Sparkle Clean",
        duration: "1 Hour",
        price: "\$20",
        image: Assets.images.test.test.path,
      ),
    ];

    return Column(
      children: [
        RowTitle(
          iconData: Icons.cleaning_services_rounded,
          title: "Available Services",
          onTap: () {
          },
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: services.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, index) {
              return SizedBox(
                width: 300.w,
                child: ServiceTile(
                  service: services[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            child: CustomImageView(
              imagePath: Assets.images.test.test.path,
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "House Cleaning",
                  style: Styles.textStyle14.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6.h),

                Text("2 Hours", style: Styles.textStyle12),

                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$25",
                      style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(onPressed: () {}, child: const Text("Book")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
