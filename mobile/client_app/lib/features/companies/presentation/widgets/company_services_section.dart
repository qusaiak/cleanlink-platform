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
