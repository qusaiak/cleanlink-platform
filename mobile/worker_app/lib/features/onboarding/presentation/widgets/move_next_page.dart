import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoveNextPage extends StatelessWidget {
  final GestureTapCallback onTap;

  const MoveNextPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 20.h,
      right: 20.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(Icons.arrow_forward_ios, color: theme.primary, size: 12),
        ),
      ),
    );
  }
}
