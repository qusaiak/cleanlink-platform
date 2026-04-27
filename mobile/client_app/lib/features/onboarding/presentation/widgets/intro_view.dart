import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';

class IntroView extends StatelessWidget {
  const IntroView(this.title, this.imageUrl, {super.key});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// 📌 TOP IMAGE ONLY
          SizedBox(
            height: 600.h,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain, // important: no cropping
                ),
              ),
            ),
          ),

          SizedBox(height: 30.h),

          /// 📌 TITLE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              title,
              style: Styles.textStyle18.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}