import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LoginSession {
  LoginSession._();

  static const String _tokenKey = 'auth_token';
  static const String _employeeIdKey = 'session_employee_id';
  static const String _addressKey = 'session_address';
  static const String _phoneKey = 'session_phone';
  static const String _avatarUrlKey = 'session_avatar_url';
  static const String _imagePathKey = 'session_image_path';
  static const String _skillsKey = 'session_skills';

  static String? employeeId;
  static String? address;
  static String? phone;

  static List<Map<String, dynamic>> skills = const [];

  static String? token;

  static String? avatarUrl;

  static String? imagePath;

  static final StreamController<String> _avatarController =
      StreamController<String>.broadcast();

  static Stream<String> get avatarChanges => _avatarController.stream;

  static final StreamController<List<Map<String, dynamic>>> _skillsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  static Stream<List<Map<String, dynamic>>> get skillsChanges =>
      _skillsController.stream;

  static bool get hasToken => token != null && token!.isNotEmpty;

  static Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    employeeId = prefs.getString(_employeeIdKey);
    address = prefs.getString(_addressKey);
    phone = prefs.getString(_phoneKey);
    avatarUrl = prefs.getString(_avatarUrlKey);
    imagePath = prefs.getString(_imagePathKey);
    skills = _decodeSkills(prefs.getString(_skillsKey));
  }

  static List<Map<String, dynamic>> _decodeSkills(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map(Map<String, dynamic>.from)
          .toList(growable: false);
    } catch (e) {
      log('LoginSession: cached skills unreadable ($e) → $raw');
      return const [];
    }
  }

  static Future<void> saveToken(String value) async {
    token = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, value);
  }

  static Future<void> saveIdentity({
    String? employeeId,
    String? address,
    String? phone,
  }) async {
    LoginSession.employeeId = employeeId ?? LoginSession.employeeId;
    LoginSession.address = address ?? LoginSession.address;
    LoginSession.phone = phone ?? LoginSession.phone;

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      if (LoginSession.employeeId != null)
        prefs.setString(_employeeIdKey, LoginSession.employeeId!),
      if (LoginSession.address != null)
        prefs.setString(_addressKey, LoginSession.address!),
      if (LoginSession.phone != null)
        prefs.setString(_phoneKey, LoginSession.phone!),
    ]);
  }

  static Future<void> saveProfileImage({
    required String displayUrl,
    String? storedPath,
  }) async {
    avatarUrl = displayUrl;
    if (storedPath != null && storedPath.isNotEmpty) imagePath = storedPath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarUrlKey, displayUrl);
    if (imagePath != null) await prefs.setString(_imagePathKey, imagePath!);

    if (!_avatarController.isClosed) _avatarController.add(displayUrl);
  }

  static Future<void> saveSkills(List<Map<String, dynamic>> value) async {
    skills = List<Map<String, dynamic>>.unmodifiable(value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_skillsKey, jsonEncode(skills));

    if (!_skillsController.isClosed) _skillsController.add(skills);
  }

  static Future<void> clear() async {
    token = null;
    employeeId = null;
    address = null;
    phone = null;
    avatarUrl = null;
    imagePath = null;
    skills = const [];

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_tokenKey),
      prefs.remove(_employeeIdKey),
      prefs.remove(_addressKey),
      prefs.remove(_phoneKey),
      prefs.remove(_avatarUrlKey),
      prefs.remove(_imagePathKey),
      prefs.remove(_skillsKey),
    ]);

    if (!_avatarController.isClosed) _avatarController.add('');
    if (!_skillsController.isClosed) _skillsController.add(const []);
  }
}
