import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storable.dart';
import 'storage_data.dart';

abstract class SharedStorage {
  SharedStorage._();

  static SharedPreferences? _sharedPreferences;
  static FlutterSecureStorage? _secureStorage;

  static final _sessionIdKey = StorageData.token.storableKey;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<T?> get<T>(Storable key) async {
    if (!(await SharedStorage.hasData(key))) return null;

    if (key.secure) {
      try {
        final value = await _secureStorage!.read(key: key.storableKey);
        if (value == null) return null;
        final parsedValue = value;
        return parsedValue as T?;
      } on PlatformException catch (e) {
        debugPrint(
          'Error reading secure storage for key ${key.storableKey}: $e',
        );
        try {
          await _secureStorage!.delete(key: key.storableKey);
        } catch (_) {
        }
        return null;
      }
    }

    return _sharedPreferences?.get(key.storableKey) as T?;
  }

  static Future<bool?> getBool(Storable key) async {
    final value = await get<Object>(key);
    return parseBool(value);
  }

  static bool? parseBool(Object? value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return switch (value.trim().toLowerCase()) {
        'true' || '1' => true,
        'false' || '0' => false,
        _ => null,
      };
    }
    return null;
  }

  static Future<void> set<T>(Storable key, T value) async {
    final dynamic setValue;
    if (value is Enum) {
      setValue = value.name;
    } else {
      setValue = value;
    }

    if (key.secure) {
      await _secureStorage!.write(
        key: key.storableKey,
        value: value.toString(),
      );
      return;
    }

    if (setValue is String) {
      await _sharedPreferences!.setString(key.storableKey, setValue);
    } else if (setValue is List<String>) {
      await _sharedPreferences!.setStringList(key.storableKey, setValue);
    } else if (setValue is int) {
      await _sharedPreferences!.setInt(key.storableKey, setValue);
    } else if (setValue is bool) {
      await _sharedPreferences!.setBool(key.storableKey, setValue);
    } else if (setValue is double) {
      await _sharedPreferences!.setDouble(key.storableKey, setValue);
    } else {
      await _sharedPreferences!.setString(key.storableKey, setValue.toString());
    }
  }

  static Future<bool> hasData(Storable key) async {
    if (key.secure) {
      try {
        return await _secureStorage?.containsKey(key: key.storableKey) ?? false;
      } on PlatformException catch (_) {
        return false;
      }
    }
    return _sharedPreferences?.containsKey(key.storableKey) ?? false;
  }

  static Future<void> delete<T>(Storable key) async {
    if (key.secure) {
      await _secureStorage!.delete(key: key.storableKey);
      return;
    }
    await _sharedPreferences!.remove(key.storableKey);
  }

  static Future<void> setList(Storable key, List<dynamic> list) async {
    await set(key, jsonEncode(list));
  }

  static Future<List<dynamic>> getList(Storable key) async {
    final String? encodedList = await get<String>(key);
    if (encodedList != null && encodedList.isNotEmpty) {
      try {
        return List<dynamic>.from(jsonDecode(encodedList));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static Future<String?> get sessionId async {
    try {
      return await _secureStorage!.read(key: _sessionIdKey);
    } on PlatformException catch (_) {
      try {
        await _secureStorage!.delete(key: _sessionIdKey);
      } catch (_) {}
      return null;
    }
  }

  static Future<bool> get authenticated async {
    try {
      return await _secureStorage!.containsKey(key: _sessionIdKey);
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<void> clear() async {
    final storageDataValues = StorageData.values.where(
      (element) => element.clearOnLogout,
    );

    for (StorageData storageData in storageDataValues) {
      await delete(storageData);
    }
  }
}
