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
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Image.asset(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              title,
              style: Styles.textStyle18.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),

          SizedBox(height: 90.h),
        ],
      ),
    );
  }
}
