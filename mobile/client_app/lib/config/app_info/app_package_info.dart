import 'package:package_info_plus/package_info_plus.dart';

class AppPackageInfo {
  static PackageInfo? _packageInfo;

  static Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  static String get appName {
    return _packageInfo!.appName;
  }

  static String get packageName {
    return _packageInfo!.packageName;
  }

  static String get appVersion {
    return _packageInfo!.version;
  }

  static String get buildNumber {
    return _packageInfo!.buildNumber;
  }
}
