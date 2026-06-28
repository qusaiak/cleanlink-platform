import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/row_title.dart';

class CoverageAreaSection extends StatelessWidget {
  const CoverageAreaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowTitle(iconData: Icons.map_outlined, title: "Coverage Area"),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              Assets.images.test.test.path,
              height: 160.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
