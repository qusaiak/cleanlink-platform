import 'package:client_app/features/home/presentation/widgets/service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/content/content_list_view.dart';
import '../../../../core/widgets/content/content_mock_data.dart';
import '../../../../core/widgets/content/content_section_type.dart';
import '../../../../core/widgets/custom_list_section.dart';
import '../../../../core/widgets/dummy_data.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../categories/presentation/widgets/category_service_card.dart';
import '../../../services/data/models/service_model.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../services/domain/entities/service_entity.dart';

class ServicesSection extends StatelessWidget {
  final List<ServiceEntity> services;
  const ServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    // final services = ServicesData.all.take(2).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      child: CustomListSection(
        title: AppLocalizations.of(context)!.popular_services,
        onTitleTap: () {
          GoRouter.of(context).push(AppRouter.kServices);
        },
        itemExtent: 200.w,
        itemCount: services.length,
        iconData: Icons.cleaning_services,
        isVertical: true,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        separator: SizedBox(height: 10.h),
        itemBuilder: (context, index) => CategoryServiceCard(
          service: services[index],
          onTap: () {
            GoRouter.of(
              context,
            ).push(AppRouter.kServiceDetails, extra: services[index].id);
          },
        ),
        //     ServiceTile(
        //   service: services[index],
        //   onTap: () {
        //     GoRouter.of(context).push(AppRouter.kServiceDetails,extra: services[index].id);
        //   },
        // ),
      ),
    );
    // return ListView.separated(
    //   padding: EdgeInsets.symmetric(horizontal: 20.w),
    //   physics: const BouncingScrollPhysics(),
    //   shrinkWrap: true,
    //   itemCount: services.length,
    //   separatorBuilder: (_, __) => SizedBox(height: 10.h),
    //   itemBuilder: (_, i) => ServiceTile(service: services[i]),
    // );
  }
}
