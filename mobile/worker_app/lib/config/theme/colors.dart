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

  // Semantic — aligned to the documented brand spec (previous hex values
  // were slightly off-spec: successColor was 0xFF22C55E, warningColor was
  // 0xFFF59E0B). Meaning/usage is unchanged, only the shade is corrected.
  static const Color successColor = Color(0xFF24B364);
  static const Color warningColor = Color(0xFFFFB020);

  /// NEW — informational tone. The palette had success/error/warning but no
  /// "info", even though status badges and hints need a neutral-positive
  /// accent distinct from the brand teal.
  static const Color infoColor = Color(0xFF3B82F6);

  /// ================= LIGHT =================
  static const Color backgroundColorLight = Color(0xFFFFFFFF);
  static const Color onBackgroundColorLight = Color(0xFF0F172A);

  static const Color primaryLight = primaryColor;
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  static const Color secondaryLight = secondaryColor;
  static const Color onSecondaryLight = Color(0xFFFFFFFF);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0F172A);

  /// NEW — a faint elevated tier for light-mode cards/sheets that sit on top
  /// of the pure-white background (light mode used a single flat white for
  /// everything, giving cards no visual separation without a shadow).
  static const Color surfaceContainerLight = Color(0xFFF8FAFC);

  /// NEW — muted text/icon tone for secondary content in light mode.
  static const Color onSurfaceVariantLight = gray500;

  static const Color bottomNavigationBarLight = Color(0xFFFFFFFF);

  static const Color borderLightOnFocus = primaryColor;

  // Error — corrected from 0xFFEF4444 to the documented brand red.
  static const Color errorLight = Color(0xFFFE5151);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  /// ================= DARK =================
  static const Color backgroundColorDark = Color(0xFF0B1215);

  /// Legacy name, kept for compatibility — same tone as [surfaceDark].
  static const Color secondaryBackgroundColorDark = Color(0xFF121A1D);

  static const Color primaryDark = primaryColor;
  static const Color onPrimaryDark = Color(0xFFFFFFFF);

  static const Color secondaryDark = Color(0xFF38BDF8);
  static const Color onSecondaryDark = Color(0xFF000000);

  // Dark-mode elevation ladder — previously background/secondaryBackground/
  // surface were three near-identical near-black tones with no clear
  // hierarchy. This ramp uses a teal-tinted charcoal (instead of neutral
  // gray) so dark mode still reads as part of the same brand, with each
  // step a little lighter to convey elevation.
  /// Level 1 — base surface (cards sitting directly on the background).
  static const Color surfaceDark = Color(0xFF121A1D);

  /// NEW — Level 2, elevated cards/content panels.
  static const Color surfaceContainerDark = Color(0xFF17242A);

  /// NEW — Level 3, app bar / bottom navigation.
  static const Color surfaceContainerHighDark = Color(0xFF1C2C33);

  /// NEW — Level 4, dialogs / modals / bottom sheets (topmost elevation).
  static const Color surfaceContainerHighestDark = Color(0xFF22343B);

  // Softened from pure white so large blocks of dark-mode text are less
  // harsh, matching the "not an afterthought" dark theme goal.
  static const Color onSurfaceDark = Color(0xFFF1F5F9);

  /// NEW — muted text/icon tone for secondary content in dark mode.
  static const Color onSurfaceVariantDark = gray400;

  static const Color bottomNavigationBarDark = surfaceContainerHighDark;

  static const Color borderDarkOnFocus = primaryColor;

  // Error — corrected from 0xFFEF4444 to the documented brand red.
  static const Color errorDark = Color(0xFFFE5151);
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

  /// ================= DIVIDERS / OUTLINES (NEW) =================
  static const Color dividerLight = gray200;
  static const Color dividerDark = Color(0xFF223038);

  /// ================= SOFT / TINTED BACKGROUNDS (NEW) =================
  /// "Soft background + colored text/icon" treatment for badges, chips and
  /// inline alerts — a lower-opacity wash of each semantic/brand color
  /// rather than a solid fill, used for a calmer, more modern look.
  static Color get primarySoft => primaryColor.withValues(alpha: 0.10);
  static Color get secondarySoft => secondaryColor.withValues(alpha: 0.14);
  static Color get accentSoft => accentColor.withValues(alpha: 0.28);
  static Color get successSoft => successColor.withValues(alpha: 0.14);
  static Color get warningSoft => warningColor.withValues(alpha: 0.16);
  static Color get errorSoft => errorLight.withValues(alpha: 0.12);
  static Color get infoSoft => infoColor.withValues(alpha: 0.14);

  /// ================= GRADIENTS (NEW) =================
  /// Subtle brand gradient for primary CTAs / highlighted surfaces — kept
  /// within the teal family so it reads as a richer primaryColor, not a
  /// different hue.
  static const List<Color> primaryGradientColors = [
    primaryColor,
    primaryColorDarker,
  ];

  /// ================= SHIMMER =================
  static Color shimmerBaseColor = Colors.grey[300]!;
  static Color shimmerHighlightColor = Colors.grey[100]!;

  /// NEW — dark-mode shimmer tones, tinted to match [surfaceContainerDark]
  /// instead of reusing the light-mode neutral grays (which would look like
  /// a washed-out gray patch on a dark screen).
  static const Color shimmerBaseColorDark = Color(0xFF1C2A2E);
  static const Color shimmerHighlightColorDark = Color(0xFF2A3D42);

  static Color shimmerBaseFor(Brightness brightness) =>
      brightness == Brightness.dark ? shimmerBaseColorDark : shimmerBaseColor;

  static Color shimmerHighlightFor(Brightness brightness) =>
      brightness == Brightness.dark
          ? shimmerHighlightColorDark
          : shimmerHighlightColor;
}
