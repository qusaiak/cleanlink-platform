import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

/// The signed-in worker's session: bearer token, the job id / address / phone
/// captured from the login response, and the profile photo.
///
/// Everything here is kept in memory (so the Dio interceptor can read the token
/// synchronously, at request time, and never work from a stale copy) AND
/// mirrored into [SharedPreferences] so it survives a cold start.
///
/// Write order is deliberate everywhere below: the in-memory field is set
/// FIRST, the (async) preferences write is awaited SECOND. Callers that await a
/// `save*` therefore have both a live and a persisted value before they
/// continue — which is what makes "navigate only after the token is stored"
/// actually true.
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

  /// The worker's own skills, cached exactly as the API returns them inside
  /// `worker_profile.skills` — raw maps (`{id, name_ar, name_en}`), NOT domain
  /// objects, so this core-level session stays free of feature imports.
  ///
  /// Both localized names are kept, which is what lets the cached chips
  /// re-localize on a language switch without a request.
  static List<Map<String, dynamic>> skills = const [];

  /// Bearer token for every authenticated request. Read fresh by the shared
  /// Dio interceptor on each request, so it is never baked into the client.
  static String? token;

  /// The photo's DISPLAY url (already passed through
  /// `ApiUrlParameters.resolveImageUrl`) — what the avatar widgets render.
  static String? avatarUrl;

  /// The photo's STORED path exactly as the server returned it from the upload
  /// (e.g. `storage\app\public\task_images\xxxx.jpg`). Kept verbatim —
  /// never trimmed, escaped or slash-normalised — because it is what
  /// `POST /api/worker-profiles/update-image` expects back as its `image` value.
  static String? imagePath;

  /// Broadcasts the new display url whenever the photo changes, so every screen
  /// showing the avatar (profile header, home top bar, drawer) refreshes
  /// immediately — each holds its own `WorkerProfileBloc` instance and would
  /// otherwise keep the old picture until it re-fetched.
  static final StreamController<String> _avatarController =
      StreamController<String>.broadcast();

  /// App-lifetime stream — subscribe to keep an avatar in sync.
  static Stream<String> get avatarChanges => _avatarController.stream;

  /// Broadcasts the worker's new skill set whenever it changes, for the same
  /// reason [avatarChanges] exists: every screen builds its OWN
  /// `WorkerProfileBloc` (registered as a factory), so an attach/detach done on
  /// the skills screen would otherwise leave the profile screen showing the old
  /// chips until it re-fetched.
  static final StreamController<List<Map<String, dynamic>>> _skillsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  /// App-lifetime stream — subscribe to keep a skills list in sync.
  static Stream<List<Map<String, dynamic>>> get skillsChanges =>
      _skillsController.stream;

  static bool get hasToken => token != null && token!.isNotEmpty;

  /// Loads the persisted session. Awaited from `initializeDependencies()` so
  /// nothing can read a half-initialized session (in particular: no request can
  /// be built before the token is known).
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

  /// Reads back the persisted skills. A corrupt/legacy value is dropped rather
  /// than thrown: a broken cache must never stop the app from starting — the
  /// next profile fetch refills it from the server anyway.
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

  /// Persists the bearer [value]. Awaiting this guarantees the token is both
  /// live and stored before the caller navigates or fires the next
  /// authenticated request.
  static Future<void> saveToken(String value) async {
    token = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, value);
  }

  /// Persists the identity fields captured from the login response.
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

  /// Caches the confirmed profile photo and notifies every listener.
  ///
  /// [displayUrl] is what the avatar widgets render; [storedPath] is the raw
  /// server path kept verbatim for a later `update-image` call. Called only
  /// with values the SERVER confirmed, so the cache can never drift from the
  /// backend.
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

  /// Caches the worker's skills and notifies every listener.
  ///
  /// Called ONLY with the set the SERVER confirmed (the attach/detach responses
  /// carry the full updated user), so the cache can never drift from the
  /// backend — and so the chips are already right on the next cold start,
  /// before the profile fetch comes back.
  static Future<void> saveSkills(List<Map<String, dynamic>> value) async {
    skills = List<Map<String, dynamic>>.unmodifiable(value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_skillsKey, jsonEncode(skills));

    if (!_skillsController.isClosed) _skillsController.add(skills);
  }

  /// Wipes the session from memory and from storage (logout). Awaited before
  /// the service locator is rebuilt so nothing can restore what was just
  /// cleared.
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
