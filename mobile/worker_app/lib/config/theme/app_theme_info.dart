import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeInfo {
  static const String _prefsKey = 'is_light_theme';

  static bool _isLight = true;

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
