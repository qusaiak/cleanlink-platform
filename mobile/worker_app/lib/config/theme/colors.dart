import 'package:flutter/material.dart';

abstract class AppColor {
  const AppColor();

  // General
  static const Color dialogSuccess = Color(0xFF22C55E);
  static const Color dialogFailed = Color(0xFFEF4444);
  static const Color transparent = Colors.transparent;

  // Primary (Teal - Cleaning identity)
  static const Color primaryColor = Color(0xFF00A8A8);
  static const Color primaryColorLighter = Color(0xFF4FD1C5);
  static const Color primaryColorDarker = Color(0xFF007C7C);

  // Secondary (Trust / UI balance)
  static const Color secondaryColor = Color(0xFF4FC3F7);
  static const Color secondaryColorDark = Color(0xFF0288D1);

  // Accent (Success / eco feeling)
  static const Color accentColor = Color(0xFFA5D6A7);

  /// ================= LIGHT =================
  static const Color backgroundColorLight = Color(0xFFFFFFFF);
  static const Color onBackgroundColorLight = Color(0xFF0F172A);

  static const Color primaryLight = primaryColor;
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  static const Color secondaryLight = secondaryColor;
  static const Color onSecondaryLight = Color(0xFFFFFFFF);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0F172A);

  static const Color bottomNavigationBarLight = Color(0xFFFFFFFF);

  static const Color borderLightOnFocus = primaryColor;
  static const Color errorLight = Color(0xFFEF4444);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  static const Color successColor = Color(0xFF22C55E);

  /// ================= DARK =================
  static const Color backgroundColorDark = Color(0xFF0B1215);
  static const Color secondaryBackgroundColorDark = Color(0xFF121A1D);

  static const Color primaryDark = primaryColor;
  static const Color onPrimaryDark = Color(0xFFFFFFFF);

  static const Color secondaryDark = Color(0xFF38BDF8);
  static const Color onSecondaryDark = Color(0xFF000000);

  static const Color surfaceDark = Color(0xFF121212);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  static const Color bottomNavigationBarDark = Color(0xFF121A1D);

  static const Color borderDarkOnFocus = primaryColor;
  static const Color errorDark = Color(0xFFEF4444);
  static const Color onErrorDark = Color(0xFFFFFFFF);

  /// ================= GRAYS =================
  static const Color gray100 = Color(0xFFF8FAFC);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  /// ================= SHIMMER =================
  static Color shimmerBaseColor = Colors.grey[300]!;
  static Color shimmerHighlightColor = Colors.grey[100]!;
}