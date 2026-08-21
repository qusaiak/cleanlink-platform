import 'dart:async';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageInfo {
  static const String _prefsKey = 'language_code';

  static String _languageCode = "en";

  static final StreamController<String> _changes =
      StreamController<String>.broadcast();

  static Stream<String> get changes => _changes.stream;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString(_prefsKey) ?? _languageCode;
  }

  static String get languageCode {
    return _languageCode;
  }

  static bool get isEn {
    return _languageCode == "en";
  }

  static bool get isAr {
    return _languageCode == "ar";
  }

  static Locale get locale {
    return Locale(_languageCode);
  }

  static Future<void> setLanguageCode(String code) async {
    if (code == _languageCode) return;

    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);

    if (!_changes.isClosed) _changes.add(code);
  }
}
