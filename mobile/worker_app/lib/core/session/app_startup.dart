import 'package:shared_preferences/shared_preferences.dart';

/// One-time startup facts that decide the very first screen, kept separate from
/// [LoginSession] (auth) on purpose: these MUST survive a logout.
///
/// Currently just "has onboarding ever been completed". Held in memory (so the
/// splash can branch synchronously after [initialize]) and mirrored into
/// [SharedPreferences] so the choice survives a cold start — this is the fix
/// for the "onboarding shows on every launch" bug: the flag was never
/// persisted before.
class AppStartup {
  AppStartup._();

  static const String _onboardingDoneKey = 'onboarding_completed';

  static bool _onboardingCompleted = false;

  /// Loads the persisted flag. Awaited during app bootstrap, before the router
  /// is built, so the splash can decide where to go without an async gap.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingCompleted = prefs.getBool(_onboardingDoneKey) ?? false;
  }

  static bool get onboardingCompleted => _onboardingCompleted;

  /// Marks onboarding as finished (skip or last page). Persisted so it is never
  /// shown again. Deliberately NOT cleared on logout.
  static Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingDoneKey, true);
  }
}
