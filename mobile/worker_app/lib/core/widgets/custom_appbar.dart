
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/theme/app_theme_info.dart';

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
    title: Text(title, style: TextStyle(color: color)),
    actions: actions,
  );
}
