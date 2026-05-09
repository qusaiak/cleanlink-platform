import 'dart:io';
import 'dart:ui';
import '../../core/storage/shared_storage.dart';
import '../../core/storage/storage_data.dart';

class AppLanguageInfo {
  static String _languageCode = "en";

  static Future<void> initialize() async {
    if (!await SharedStorage.hasData(StorageData.languageCode)) {
      String languageSystem = Platform.localeName.split('_')[0];
      _languageCode = languageSystem;
      await setLanguageCode(_languageCode);
    } else {
      _languageCode = await SharedStorage.get(StorageData.languageCode);
    }
  }

  static String get languageCode {
    return _languageCode;
  }

  static bool get isEn {
    return _languageCode == "en";
  }

  static Locale get locale {
    return Locale(_languageCode);
  }

  static Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    await SharedStorage.set(StorageData.languageCode, code);
  }
}
