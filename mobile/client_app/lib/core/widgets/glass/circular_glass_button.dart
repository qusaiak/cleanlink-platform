import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/colors.dart';

class CircularGlassButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const CircularGlassButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var color = isActive
        ? activeColor
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final size = 36.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? activeColor.withValues(alpha: 0.6) : color,
                  width: 1.5,
                ),
                color: Colors.transparent,
              ),
              child: Icon(icon, size: 20.r, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
