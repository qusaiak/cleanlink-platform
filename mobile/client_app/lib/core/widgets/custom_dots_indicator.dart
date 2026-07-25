import 'package:client_app/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDotsIndicator extends StatelessWidget {
  final int currentIndex;
  final List contents;
  final Function(int) onDotTap;
  final double selectedWidth;
  final double width;
  final double height;
  final double spaceBetweenDots;

  const CustomDotsIndicator({
    super.key,
    required this.currentIndex,
    required this.contents,
    required this.onDotTap,
    required this.selectedWidth,
    required this.width,
    required this.height,
    required this.spaceBetweenDots,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: contents.asMap().entries.map((entry) {
        final index = entry.key;
        return GestureDetector(
          onTap: () => onDotTap(index),
          child: Container(
            width: currentIndex != index ? width : selectedWidth,
            height: height,
            margin: EdgeInsets.symmetric(horizontal: spaceBetweenDots),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.primaryColor, width: 0.5.w),
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? AppColor.primaryColor
                  : Colors.transparent,
            ),
          ),
        );
      }).toList(),
    );
  }
}
