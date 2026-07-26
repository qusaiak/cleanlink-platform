import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config_keys.dart';

class AppConfig {
  // API
  static String get baseUrl => dotenv.env[ConfigKeys.baseUrl] ?? '';
  static String get apiVersion => dotenv.env[ConfigKeys.apiVersion] ?? '';

  static String get fullApiUrl => baseUrl + apiVersion;

  static int get timeout =>
      int.parse(dotenv.env[ConfigKeys.timeout] ?? '100000');

  // Maps
  static String get googleMapsKey => dotenv.env[ConfigKeys.mapsKey] ?? '';

  // Notifications
  static String get fcmTopic => dotenv.env[ConfigKeys.fcmTopic] ?? '';

  // App behavior
  static bool get isDebug => dotenv.env[ConfigKeys.debug] == 'true';

  static bool get enableLogs => dotenv.env[ConfigKeys.enableLogs] == 'true';

  // Feature flags
  static bool get enableChat => dotenv.env[ConfigKeys.enableChat] == 'true';

  static bool get enableRatings =>
      dotenv.env[ConfigKeys.enableRatings] == 'true';

  static bool get enableTracking =>
      dotenv.env[ConfigKeys.enableTracking] == 'true';

  // Limits
  static int get defaultPageSize =>
      int.parse(dotenv.env[ConfigKeys.pageSize] ?? '10');

  static int get maxBookingPerDay =>
      int.parse(dotenv.env[ConfigKeys.maxBooking] ?? '3');
}
