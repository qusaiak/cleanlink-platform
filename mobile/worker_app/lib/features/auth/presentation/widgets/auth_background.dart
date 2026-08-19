import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColor.backgroundColorDark
          : AppColor.backgroundColorLight,
      body: SafeArea(child: child),
    );
  }
}
