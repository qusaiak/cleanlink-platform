import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/row_title.dart';

class BeforeAfterGallery extends StatelessWidget {
  const BeforeAfterGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(
          iconData: Icons.compare_arrows,
          title: "Before & After",
          onTap: () {},
          padding: EdgeInsets.all(0),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  children: [
                    Image.asset(
                      Assets.images.test.test.path,
                      width: 140.w,
                      height: 160.h,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        color: Colors.black.withOpacity(0.6),
                        child: Text(
                          index == 0
                              ? "Living Room"
                              : index == 1
                              ? "Kitchen"
                              : "Bathroom",
                          textAlign: TextAlign.center,
                          style: Styles.textStyle11.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
