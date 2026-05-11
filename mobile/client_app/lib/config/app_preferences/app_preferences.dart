import '../../core/storage/shared_storage.dart';
import '../../core/storage/storage_data.dart';

class AppPreferences {
  static String _deviceToken = "";
  static String _notificationState = "";

  static Future<void> initialize() async {
    _deviceToken = await SharedStorage.get(StorageData.fcmToken) ?? '';
    _notificationState = await SharedStorage.get(StorageData.pushNotifications) ?? '';
  }

  static String get deviceToken {
    return _deviceToken;
  }

  static String get notificationState {
    return _notificationState;
  }

  static Future<void> setDeviceToken(String deviceToken) async {
    _deviceToken = deviceToken;
    await SharedStorage.set(StorageData.fcmToken, deviceToken);
  }

  static Future<void> setNotificationState(String notificationState) async {
    _notificationState = notificationState;
    await SharedStorage.set(StorageData.pushNotifications, notificationState);
  }
}
