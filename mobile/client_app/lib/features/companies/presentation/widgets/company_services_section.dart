import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/dummy_data.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../services/data/models/service_model.dart';
import '../../../home/presentation/widgets/service_tile.dart';

class CompanyServicesSection extends StatelessWidget {
  final List<ServiceEntity> services;
  const CompanyServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    // final services = ServicesData.all;

    return Column(
      children: [
        RowTitle(
          iconData: Icons.cleaning_services_rounded,
          title: "Available Services",
          onTap: () {},
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
                  onTap: () {
                    GoRouter.of(context).push(
                      AppRouter.kServiceDetails,
                      extra: services[index].id,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
