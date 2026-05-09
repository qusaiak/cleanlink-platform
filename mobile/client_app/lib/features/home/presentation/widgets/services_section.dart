import 'package:client_app/features/home/presentation/widgets/service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/service_model.dart';
import '../../../../core/utils/gen/assets.gen.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = ServicesData.all.take(2).toList();

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: services.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => ServiceTile(service: services[i]),
    );
  }
}
