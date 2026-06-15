import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../config/theme/colors.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.isOutlined = false,
    this.borderRadius = 20,
  }) : assert(label != null || label == null, 'Icon is required');

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final bool isOutlined;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: isOutlined ? _outlined() : _filled(),
      ),
    );
  }

  Widget _filled() {
    if (label == null) {
      // Icon-only button
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor.withValues(alpha: 0.8),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.all(12),
          minimumSize: const Size(40, 40),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 20),
      label: Text(label!, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor.withValues(alpha: 0.8),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _outlined() {
    if (label == null) {
      // Icon-only outlined button
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.all(12),
          minimumSize: const Size(40, 40),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label!, style: const TextStyle(color: Colors.white)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
