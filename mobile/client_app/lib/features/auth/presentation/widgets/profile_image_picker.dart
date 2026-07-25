import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final hasImage = imagePath.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary,
            ),
            child: CircleAvatar(
              radius: 55.r,
              backgroundColor: theme.onSurface.withValues(alpha: 0.08),
              backgroundImage: hasImage ? FileImage(File(imagePath)) : null,
              child: !hasImage
                  ? Icon(
                      Icons.person,
                      size: 48.r,
                      color: theme.onSurface.withValues(alpha: 0.5),
                    )
                  : null,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primaryColor,
              border: Border.all(color: theme.surface, width: 2),
            ),
            child: Icon(Icons.camera_alt, color: Colors.white, size: 18.r),
          ),
        ],
      ),
    );
  }
}
