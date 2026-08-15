
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:worker_app/config/theme/styles.dart';
import '../../config/language/app_language_info.dart';
import '../../core/utils/gen/fonts.gen.dart';
import 'app_decoration.dart';
import 'colors.dart';

ThemeData lightTheme() {
  final colorScheme = ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColor.primaryLight,
    onPrimary: AppColor.onPrimaryLight,
    primaryContainer: Color.alphaBlend(
      AppColor.primaryColor.withValues(alpha: 0.14),
      AppColor.surfaceLight,
    ),
    onPrimaryContainer: AppColor.primaryColorDarker,
    secondary: AppColor.secondaryLight,
    onSecondary: AppColor.onSecondaryLight,
    secondaryContainer: Color.alphaBlend(
      AppColor.secondaryColor.withValues(alpha: 0.16),
      AppColor.surfaceLight,
    ),
    onSecondaryContainer: AppColor.secondaryColorDark,
    error: AppColor.errorLight,
    onError: AppColor.onErrorLight,
    surface: AppColor.surfaceLight,
    onSurface: AppColor.onSurfaceLight,
    onSurfaceVariant: AppColor.onSurfaceVariantLight,
    outline: AppColor.gray300,
    outlineVariant: AppColor.dividerLight,
    surfaceContainerLowest: AppColor.surfaceLight,
    surfaceContainerLow: AppColor.surfaceLight,
    surfaceContainer: AppColor.surfaceContainerLight,
    surfaceContainerHigh: AppColor.gray200,
    surfaceContainerHighest: AppColor.gray200,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppLanguageInfo.isEn ? FontFamily.poppins : FontFamily.cairo,
    scaffoldBackgroundColor: AppColor.backgroundColorLight,
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColor.bottomNavigationBarLight,
    ),
    primaryColor: AppColor.primaryColor,
    primaryColorLight: AppColor.primaryLight,
    primaryColorDark: AppColor.primaryDark,
    splashColor: AppColor.primarySoft,
    highlightColor: AppColor.primaryColor.withValues(alpha: 0.05),
    dividerColor: AppColor.dividerLight,
    dividerTheme: const DividerThemeData(
      color: AppColor.dividerLight,
      thickness: 1,
      space: 1,
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
    appBarTheme: appBarLightTheme(),
    bottomNavigationBarTheme: bottomNavigationBarThemeDataLight(),
    cardTheme: CardThemeData(
      color: AppColor.surfaceContainerLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor.surfaceLight,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: AppColor.gray300,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.gray800,
      contentTextStyle: Styles.textStyle14.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.onSurfaceLight.withValues(alpha: 0.04),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: AppColor.onSurfaceLight.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: AppColor.onSurfaceLight.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColor.primaryColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColor.errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColor.errorLight, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColor.gray300,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: Styles.textStyle16.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.primaryColor,
        side: const BorderSide(color: AppColor.primaryColor, width: 1.4),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: Styles.textStyle16.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: Styles.textStyle14.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    colorScheme: colorScheme,
  );
}

ThemeData darkTheme() {
  final colorScheme = ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColor.primaryDark,
    onPrimary: AppColor.onPrimaryDark,
    primaryContainer: Color.alphaBlend(
      AppColor.primaryColor.withValues(alpha: 0.22),
      AppColor.surfaceContainerDark,
    ),
    onPrimaryContainer: AppColor.primaryColorLighter,
    secondary: AppColor.secondaryDark,
    onSecondary: AppColor.onSecondaryDark,
    secondaryContainer: Color.alphaBlend(
      AppColor.secondaryDark.withValues(alpha: 0.20),
      AppColor.surfaceContainerDark,
    ),
    onSecondaryContainer: AppColor.secondaryDark,
    error: AppColor.errorDark,
    onError: AppColor.onErrorDark,
    surface: AppColor.surfaceDark,
    onSurface: AppColor.onSurfaceDark,
    onSurfaceVariant: AppColor.onSurfaceVariantDark,
    outline: AppColor.gray600,
    outlineVariant: AppColor.dividerDark,
    surfaceContainerLowest: AppColor.backgroundColorDark,
    surfaceContainerLow: AppColor.surfaceDark,
    surfaceContainer: AppColor.surfaceContainerDark,
    surfaceContainerHigh: AppColor.surfaceContainerHighDark,
    surfaceContainerHighest: AppColor.surfaceContainerHighestDark,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppLanguageInfo.isEn ? FontFamily.poppins : FontFamily.cairo,
    scaffoldBackgroundColor: AppColor.backgroundColorDark,
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColor.bottomNavigationBarDark,
    ),
    primaryColor: AppColor.primaryColor,
    primaryColorLight: AppColor.primaryLight,
    primaryColorDark: AppColor.primaryDark,
    splashColor: AppColor.primaryColorLighter.withValues(alpha: 0.08),
    highlightColor: AppColor.primaryColorLighter.withValues(alpha: 0.04),
    dividerColor: AppColor.dividerDark,
    dividerTheme: const DividerThemeData(
      color: AppColor.dividerDark,
      thickness: 1,
      space: 1,
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
    appBarTheme: appBarDarkTheme(),
    bottomNavigationBarTheme: bottomNavigationBarThemeDataDark(),
    cardTheme: CardThemeData(
      color: AppColor.surfaceContainerDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.surfaceContainerHighestDark,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor.surfaceContainerHighDark,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: AppColor.gray600,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    ),
    // Inverse surface (light-on-dark), mirroring the light theme's
    // dark-on-light snackbar so it still pops as a floating toast instead of
    // blending into the surrounding dark screen.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.gray200,
      contentTextStyle: Styles.textStyle14.copyWith(color: AppColor.gray900),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.onSurfaceDark.withValues(alpha: 0.05),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: AppColor.onSurfaceDark.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: AppColor.onSurfaceDark.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColor.primaryColorLighter, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColor.errorDark),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColor.errorDark, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColor.gray700,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: Styles.textStyle16.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.primaryColorLighter,
        side: const BorderSide(color: AppColor.primaryColorLighter, width: 1.4),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: Styles.textStyle16.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primaryColorLighter,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: Styles.textStyle14.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    colorScheme: colorScheme,
  );
}

AppBarTheme appBarLightTheme() {
  return AppBarTheme(
    backgroundColor: AppColor.surfaceLight,
    foregroundColor: AppColor.onSurfaceLight,
    elevation: 0,
    scrolledUnderElevation: 3,
    shadowColor: AppColor.primaryColorDarker.withValues(alpha: 0.10),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    iconTheme: const IconThemeData(color: AppColor.primaryColor, size: 22),
    actionsIconTheme: const IconThemeData(color: AppColor.primaryColor, size: 22),
    titleTextStyle: Styles.textStyle18.copyWith(
      color: AppColor.primaryColor,
      fontWeight: FontWeight.bold,
      fontFamily: AppLanguageInfo.isEn ? FontFamily.poppins : FontFamily
          .cairo,
    ),
  );
}

AppBarTheme appBarDarkTheme() {
  return AppBarTheme(
    backgroundColor: AppColor.surfaceContainerHighDark,
    foregroundColor: AppColor.onSurfaceDark,
    elevation: 0,
    scrolledUnderElevation: 3,
    shadowColor: Colors.black.withValues(alpha: 0.4),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    iconTheme: const IconThemeData(color: AppColor.primaryColorLighter, size: 22),
    actionsIconTheme: const IconThemeData(color: AppColor.primaryColorLighter, size: 22),
    titleTextStyle: Styles.textStyle18.copyWith(
      color: AppColor.primaryColorLighter,
      fontWeight: FontWeight.bold,
      fontFamily: AppLanguageInfo.isEn ? FontFamily.poppins : FontFamily
          .cairo,
    ),
  );
}

BottomNavigationBarThemeData bottomNavigationBarThemeDataLight() {
  return BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    backgroundColor: AppColor.bottomNavigationBarLight,
    selectedIconTheme: const IconThemeData(
      size: 24,
      color: AppColor.primaryColor,
    ),
    selectedLabelStyle: Styles.textStyle12.copyWith(fontWeight: FontWeight.w600),
    selectedItemColor: AppColor.primaryColor,
    unselectedIconTheme: const IconThemeData(
      size: 24,
      color: AppColor.onSurfaceVariantLight,
    ),
    unselectedItemColor: AppColor.onSurfaceVariantLight,
    unselectedLabelStyle: Styles.textStyle12,
    showUnselectedLabels: true,
  );
}

BottomNavigationBarThemeData bottomNavigationBarThemeDataDark() {
  return BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    backgroundColor: AppColor.bottomNavigationBarDark,
    selectedIconTheme: const IconThemeData(
      size: 24,
      color: AppColor.primaryColorLighter,
    ),
    selectedLabelStyle: Styles.textStyle12.copyWith(fontWeight: FontWeight.w600),
    selectedItemColor: AppColor.primaryColorLighter,
    unselectedIconTheme: const IconThemeData(
      size: 24,
      color: AppColor.onSurfaceVariantDark,
    ),
    unselectedItemColor: AppColor.onSurfaceVariantDark,
    unselectedLabelStyle: Styles.textStyle12,
    showUnselectedLabels: true,
  );
}
