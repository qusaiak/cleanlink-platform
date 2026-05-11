import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum BuildMode { debug, profile, release }

class AppDeviceInfo {
  static AndroidDeviceInfo? _androidInfo;
  static IosDeviceInfo? _iosInfo;
  static String? _uniqueDeviceId;

  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      _androidInfo = await DeviceInfoPlugin().androidInfo;
    } else if (Platform.isIOS) {
      _iosInfo = await DeviceInfoPlugin().iosInfo;
    }
    _uniqueDeviceId = await _generateUniqueDeviceId();
  }

  static BuildMode get currentBuildMode {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.release;
    }
    var result = BuildMode.profile;
    assert(() {
      result = BuildMode.debug;
      return true;
    }());
    return result;
  }

  static String get osVersion {
    if (Platform.isAndroid) {
      return _androidInfo!.version.release;
    } else if (Platform.isIOS) {
      return _iosInfo!.systemVersion;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get mobileModel {
    if (Platform.isAndroid) {
      return _androidInfo!.model;
    } else if (Platform.isIOS) {
      return _iosInfo!.model;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get mobileManufacturer {
    if (Platform.isAndroid) {
      return _androidInfo!.manufacturer;
    } else if (Platform.isIOS) {
      return _iosInfo!.name;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static int get platform {
    if (Platform.isAndroid) {
      return 1;
    }
    if (Platform.isIOS) {
      return 2;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get uniqueDeviceId {
    return _uniqueDeviceId!;
  }

  static Future<AndroidDeviceInfo> get androidDeviceInfo async {
    if (_androidInfo != null) return _androidInfo!;
    return await DeviceInfoPlugin().androidInfo;
  }

  static Future<IosDeviceInfo> get iosDeviceInfo async {
    if (_iosInfo != null) return _iosInfo!;
    return await DeviceInfoPlugin().iosInfo;
  }

  static Future<String> _generateUniqueDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      String mSzDevIDShort =
          "35${androidInfo.board.length % 10}${androidInfo.brand.length % 10}${androidInfo.device.length % 10}${androidInfo.manufacturer.length % 10}${androidInfo.model.length % 10}${androidInfo.product.length % 10}";

      String serial = androidInfo.id;

      return const Uuid().v5(Uuid.NAMESPACE_DNS, mSzDevIDShort + serial);
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      return iosInfo.identifierForVendor!;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
