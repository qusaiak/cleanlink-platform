import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/gen/assets.gen.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 100.r;

    return Hero(
      tag: 'auth-logo',
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: SizedBox(
          width: dimension,
          height: dimension,
          child: Assets.images.logo.appLogo.image(
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}