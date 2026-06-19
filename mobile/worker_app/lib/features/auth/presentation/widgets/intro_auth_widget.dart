
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';

class IntroAuthWidget extends StatelessWidget {
  const IntroAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: Assets.images.placeholders.imagePlaceholder.path,
            width: 100.h,
            height: 100.h,
          ),
          SizedBox(
            height: 100.h,
          ),
        ],
      ),
    );
  }
}
