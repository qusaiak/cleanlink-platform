import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Single source of truth for where the backend lives.
///
/// The host is resolved ONCE at startup ([init]) and cached, because the right
/// host depends on where the app is actually running:
///
/// | Target                    | Host                        |
/// |---------------------------|-----------------------------|
/// | Android emulator          | `10.0.2.2` (host loopback)  |
/// | Android physical device   | [kLanHost]                  |
/// | iOS simulator             | `localhost`                 |
/// | iOS physical device       | [kLanHost]                  |
/// | Web                       | `localhost`                 |
/// | Windows / macOS / Linux   | `localhost`                 |
///
/// A physical phone can reach NEITHER `localhost` (that is the phone itself)
/// NOR `10.0.2.2` (an alias that only the Android emulator's network stack
/// understands), which is why the LAN branch exists at all.
///
/// For a real device to work, three things outside this file must hold:
///  1. phone and dev machine on the SAME Wi-Fi network;
///  2. Laravel started with `php artisan serve --host=0.0.0.0 --port=8000`
///     (the default binds to 127.0.0.1 and refuses every non-local client);
///  3. the machine's firewall allows inbound TCP on port 8000.
class ApiConfig {
  ApiConfig._();

  /// The dev machine's LAN IP — the ONE place it is written down.
  ///
  /// Change it here when the machine's address changes, or override it per-run
  /// without touching code:
  /// `flutter run --dart-define=LAN_HOST=192.168.1.50`
  static const String kLanHost = '192.168.1.107';

  /// Effective LAN host: the `--dart-define` wins, [kLanHost] is the default.
  static const String _lanHost = String.fromEnvironment(
    'LAN_HOST',
    defaultValue: kLanHost,
  );

  /// Full manual override, beating auto-detection entirely (staging servers,
  /// a tunnel, a colleague's machine):
  /// `flutter run --dart-define=BASE_URL=http://1.2.3.4:8000/api`
  static const String _overrideBaseUrl = String.fromEnvironment('BASE_URL');

  static const int _port = 8000;
  static const String _apiPrefix = '/api';

  /// The resolved API root, e.g. `http://10.0.2.2:8000/api`.
  ///
  /// Seeded with the synchronous best guess (emulator/simulator/desktop) so a
  /// read BEFORE [init] — or after a detection failure — still yields a usable
  /// URL rather than an empty string that would fail every request with
  /// "No host specified in URI".
  static String _baseUrl =
      "https://displayed-abc-promo-historical.trycloudflare.com/";

  /// Non-null once [init] has been started; makes repeated calls idempotent
  /// (and safe to await concurrently) instead of re-probing the device.
  static Future<void>? _initialization;

  /// What [_isPhysicalDevice] decided, kept for the startup diagnostic only.
  ///
  /// It is the single branch that separates "emulator" from "real phone", and
  /// a wrong answer there sends a real device to `10.0.2.2` — an address only
  /// the emulator's network stack understands — where every request times out.
  /// Printing it turns that from a silent mystery into one visible line.
  static bool? _physicalDevice;

  /// Hosts that mean "the machine this app is talking to", in every spelling a
  /// backend or a cached URL might use.
  ///
  /// `10.0.2.2` is in here for a reason that only bites on real hardware: an
  /// absolute URL resolved while running on the EMULATOR can be persisted
  /// (e.g. `LoginSession.avatarUrl` in SharedPreferences) and then read back on
  /// a physical device, where it is unreachable. Treating it as local means it
  /// gets rewritten to the current host instead of quietly failing to load.
  static const Set<String> _localHosts = {
    'localhost',
    '127.0.0.1',
    '0.0.0.0',
    '10.0.2.2',
    '::1',
    '[::1]',
  };

  /// Whether [host] is one of the loopback/emulator aliases that has to be
  /// rewritten to [baseUrl]'s host before a device can reach it.
  static bool isLocalHost(String host) =>
      _localHosts.contains(host.toLowerCase());

  /// Resolves the base URL once. Call from `main()` after
  /// `WidgetsFlutterBinding.ensureInitialized()` and BEFORE `runApp()`, since
  /// device detection is async while every later read is synchronous.
  static Future<void> init() => _initialization ??= _init();

  static Future<void> _init() async {
    _baseUrl = "https://displayed-abc-promo-historical.trycloudflare.com/";
    if (kDebugMode) {
      // Printed once, before the first request, so the address the device is
      // REALLY calling is a fact on the console rather than an assumption.
      // On a physical device `physicalDevice` must read `true` and the host
      // must be the LAN IP — `10.0.2.2` there means detection misfired and
      // every call will time out.
      debugPrint(
        '[ApiConfig] platform=$defaultTargetPlatform web=$kIsWeb '
        'physicalDevice=${_physicalDevice ?? 'n/a'}\n'
        '[ApiConfig] baseUrl  → $_baseUrl\n'
        '[ApiConfig] hostRoot → $hostRoot',
      );
    }
  }

  /// The API root every network call is built on: host + `/api`.
  static String get baseUrl => _baseUrl;

  /// [baseUrl] without the `/api` suffix — the same backend also serves
  /// non-API URLs (`/storage/...` images), and Dio's base URL is set from this
  /// because every endpoint constant in `ApiUrlParameters` already carries its
  /// own `/api/` prefix.
  static String get hostRoot => _baseUrl.endsWith(_apiPrefix)
      ? _baseUrl.substring(0, _baseUrl.length - _apiPrefix.length)
      : _baseUrl;

  static Future<String> _resolve() async {
    if (_overrideBaseUrl.isNotEmpty) return _overrideBaseUrl;

    // kIsWeb FIRST: the platform checks below are only meaningful once web is
    // ruled out. (`defaultTargetPlatform` is used instead of `dart:io`'s
    // `Platform` on purpose — importing `dart:io` at all breaks the web build
    // at COMPILE time, so no runtime guard could rescue it.)
    if (kIsWeb) return _hostUrlFor(isPhysicalDevice: false);

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        _physicalDevice = await _isPhysicalDevice();
        return _hostUrlFor(isPhysicalDevice: _physicalDevice!);
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        // Runs on the same machine as the backend.
        return _hostUrlFor(isPhysicalDevice: false);
    }
  }

  /// The host for the current platform, given whether this is real hardware.
  static String _hostUrlFor({required bool isPhysicalDevice}) {
    if (kIsWeb) return _url('localhost');
    if (isPhysicalDevice) return _url(_lanHost);
    // Emulators/simulators and desktop: `10.0.2.2` is the Android emulator's
    // alias for the HOST machine's loopback; everything else is already on it.
    return _url(
      defaultTargetPlatform == TargetPlatform.android
          ? '10.0.2.2'
          : 'localhost',
    );
  }

  static String _url(String host) => 'http://$host:$_port$_apiPrefix';

  /// Never lets a detection failure take the app down: an unusable URL is
  /// worse than the emulator/simulator default, and the wrong-host case is
  /// visible immediately as a connection error.
  static Future<bool> _isPhysicalDevice() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return (await deviceInfo.androidInfo).isPhysicalDevice;
        case TargetPlatform.iOS:
          return (await deviceInfo.iosInfo).isPhysicalDevice;
        default:
          return false;
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[ApiConfig] device detection failed ($error) — '
          'falling back to the emulator/simulator host.',
        );
      }
      return false;
    }
  }

  /// Guards the two ways a configured host silently produces a wrong URL:
  /// a trailing slash (→ `http://host:8000//api/...`) and a missing `/api`
  /// suffix, so `--dart-define=BASE_URL=http://1.2.3.4:8000` works as well as
  /// the fully-qualified form.
  static String _normalize(String value) {
    var normalized = value.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    if (!normalized.endsWith(_apiPrefix)) {
      normalized = '$normalized$_apiPrefix';
    }
    return normalized;
  }
}
