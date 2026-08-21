import 'package:shared_preferences/shared_preferences.dart';

class AppStartup {
  AppStartup._();

  static const String _onboardingDoneKey = 'onboarding_completed';

  static bool _onboardingCompleted = false;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingCompleted = prefs.getBool(_onboardingDoneKey) ?? false;
  }

  static bool get onboardingCompleted => _onboardingCompleted;

  static Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingDoneKey, true);
  }
}
