import 'package:carousel_slider/carousel_slider.dart';
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
import '../../../categories/presentation/widgets/category_service_card.dart';
import '../../../services/data/models/service_model.dart';
import '../../../home/presentation/widgets/service_tile.dart';

class CompanyServicesSection extends StatefulWidget {
  final List<ServiceEntity> services;
  const CompanyServicesSection({super.key, required this.services});

  @override
  State<CompanyServicesSection> createState() => _CompanyServicesSectionState();
}

class _CompanyServicesSectionState extends State<CompanyServicesSection> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowTitle(
          iconData: Icons.cleaning_services_rounded,
          title: "Available Services",
          onTap: () {},
        ),

        SizedBox(height: 12.h),
        // CarouselSlider.builder(
        //   itemCount: widget.services.length,
        //   itemBuilder: (_, index, __) {
        //     return ValueListenableBuilder<int>(
        //       valueListenable: _currentIndex,
        //       builder: (_, currentIndex, __) {
        //         return CategoryServiceCard(
        //           service: widget.services[index],
        //           onTap: () {
        //             GoRouter.of(context).push(
        //               AppRouter.kServiceDetails,
        //               extra: widget.services[index].id,
        //             );
        //           },
        //         );
        //       },
        //     );
        //   },
        //   options: CarouselOptions(
        //     height: 120.h,
        //     viewportFraction: 0.86,
        //
        //     enlargeCenterPage: true,
        //
        //     autoPlay: true,
        //     autoPlayInterval: const Duration(seconds: 4),
        //     autoPlayAnimationDuration: const Duration(milliseconds: 1200),
        //     autoPlayCurve: Curves.fastOutSlowIn,
        //
        //     pauseAutoPlayOnTouch: true,
        //     pauseAutoPlayOnManualNavigate: true,
        //
        //     onPageChanged: (index, reason) {
        //       _currentIndex.value = index;
        //     },
        //   ),
        // ),

        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: widget.services.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, index) {
              return SizedBox(
                width: 320.w,
                child:
                CategoryServiceCard(
                  service: widget.services[index],
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).push(AppRouter.kServiceDetails, extra: widget.services[index].id);
                  },
                ),
                // ServiceTile(
                //   service: services[index],
                //   onTap: () {
                //     GoRouter.of(context).push(
                //       AppRouter.kServiceDetails,
                //       extra: services[index].id,
                //     );
                //   },
                // ),
              );
            },
          ),
        ),
      ],
    );
  }
}
