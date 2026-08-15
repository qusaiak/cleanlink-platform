import '../../core/storage/shared_storage.dart';
import '../../core/storage/storage_data.dart';

class AppPreferences {
  static String _deviceToken = "";

  static Future<void> initialize() async {
    _deviceToken = await SharedStorage.get<String>(StorageData.fcmToken) ?? '';
  }

  static String get deviceToken {
    return _deviceToken;
  }

  static Future<void> setDeviceToken(String deviceToken) async {
    _deviceToken = deviceToken;
    await SharedStorage.set(StorageData.fcmToken, deviceToken);
  }
}
