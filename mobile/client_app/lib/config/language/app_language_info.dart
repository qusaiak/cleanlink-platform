import 'dart:io';
import 'dart:ui';
import '../../core/storage/shared_storage.dart';
import '../../core/storage/storage_data.dart';

class AppLanguageInfo {
  static String _languageCode = "en";

  static const List<String> supportedLanguages = ["en", "ar"];

  static Future<void> initialize() async {
    if (!await SharedStorage.hasData(StorageData.languageCode)) {
      final systemLanguage = Platform.localeName.split('_')[0];

      _languageCode = supportedLanguages.contains(systemLanguage)
          ? systemLanguage
          : "en";

      await setLanguageCode(_languageCode);
    } else {
      final savedLanguage = await SharedStorage.get(StorageData.languageCode);

      _languageCode = supportedLanguages.contains(savedLanguage)
          ? savedLanguage
          : "en";
    }
  }

  static String get languageCode => _languageCode;

  static bool get isEn => _languageCode == "en";

  static Locale get locale => Locale(_languageCode);

  static Future<void> setLanguageCode(String code) async {
    if (!supportedLanguages.contains(code)) return;

    _languageCode = code;
    await SharedStorage.set(StorageData.languageCode, code);
  }
}
