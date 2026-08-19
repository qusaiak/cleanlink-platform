import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

/// The app's current theme brightness.
///
/// Held in memory (so `MaterialApp` and any synchronous reader always see the
/// live value) and mirrored into [SharedPreferences] so the choice survives a
/// cold start. Previously this was in-memory only, which is why the app always
/// reverted to light mode on restart.
class AppThemeInfo {
  static const String _prefsKey = 'is_light_theme';

  static bool _isLight = true;

  /// Loads the persisted theme. On first ever launch (no stored value) the
  /// device's own brightness is used as a sensible default.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_prefsKey)) {
      _isLight = prefs.getBool(_prefsKey) ?? true;
    } else {
      _isLight =
          PlatformDispatcher.instance.platformBrightness == Brightness.light;
    }
  }

  static bool get isLight => _isLight;

  static bool get isDark => !_isLight;

  static Brightness get brightness =>
      _isLight ? Brightness.light : Brightness.dark;

  static Future<void> setTheme(bool isLight) async {
    _isLight = isLight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, isLight);
  }

  static Future<void> toggleTheme() => setTheme(!_isLight);
}
