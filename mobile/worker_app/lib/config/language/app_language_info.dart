import 'dart:async';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// The app's current language: the value the Dio interceptor sends as
/// `Accept-Language` on EVERY request, and the locale `MaterialApp` renders in.
///
/// The code is held in memory (so the interceptor can read it synchronously, at
/// request time, and therefore never sends a stale language) and mirrored into
/// [SharedPreferences] so the choice survives a cold start.
class AppLanguageInfo {
  static const String _prefsKey = 'language_code';

  static String _languageCode = "en";

  /// Broadcasts the NEW language code whenever it changes.
  ///
  /// Server-localized data (the skills dictionary, notification texts, …) is
  /// translated by the backend according to `Accept-Language`, never on the
  /// client — so a language switch makes every such cached payload wrong until
  /// it is fetched again. Blocs subscribe here and re-fetch, which is what
  /// makes the change visible immediately instead of after a restart.
  static final StreamController<String> _changes =
      StreamController<String>.broadcast();

  /// App-lifetime stream of language changes. Emits the new code (`ar` / `en`).
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

    // In-memory FIRST: the next request must already carry the new
    // `Accept-Language`, even if the (async) preferences write is still
    // pending — and the listeners notified below re-fetch immediately.
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);

    if (!_changes.isClosed) _changes.add(code);
  }
}
