import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/theme/app_theme_info.dart';
import '../../config/theme/colors.dart';

PreferredSizeWidget customAppBar(
    String title,
    IconData? leading,
    List<Widget>? actions,
    VoidCallback? onPressedLeading,
    Color color) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppThemeInfo.isLight
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: AppThemeInfo.isLight ? Brightness.dark : Brightness
          .light,
    ),
    leading: leading != null
        ? IconButton(
            onPressed: onPressedLeading,
            icon: Icon(
              leading,
              color: color,
            ),
          )
        : null,
    centerTitle: false,
    backgroundColor: AppColor.transparent,
    scrolledUnderElevation: 0,
    shadowColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    title: Text(title, style: TextStyle(color: color),),
    actions: actions,
  );
}
