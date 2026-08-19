import 'package:client_app/config/constants/config_keys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/session/user_session.dart';
import '../core/storage/shared_storage.dart';
import '../core/storage/storage_data.dart';
import '../core/utils/bloc_observer.dart';
import '../firebase_api.dart';
import '../injection_container.dart';
import 'app_info/app_device_info.dart';
import 'app_info/app_lifecycle_tracker.dart';
import 'app_info/app_package_info.dart';
import 'app_preferences/app_preferences.dart';
import 'constants/app_config.dart';
import 'language/app_language_info.dart';
import 'theme/app_theme_info.dart';
import '../firebase_options.dart';

abstract class Bindings {
  Bindings._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SharedStorage.init();
    await _initializeFirebase();
    await _initializeEnvironment();
    await _initializeStripe();
    await _initializeBlocObserver();
    await AppLanguageInfo.initialize();
    await AppThemeInfo.initialize();
    await AppPackageInfo.initialize();
    await AppDeviceInfo.initialize();
    await AppPreferences.initialize();
    await clearAllUserData();
    await initializeDependencies();
    await sl<UserSession>().load();
    await sl<FirebaseApi>().initNotifications();
    await sl<FirebaseApi>().syncFcmTokenWithBackend();
    _configureErrorHandling();
    AppLifecycleTracker();
  }

  static Future<void> clearAllUserData() async {
    if (!await SharedStorage.hasData(StorageData.isOnboarding)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      const secureStorage = FlutterSecureStorage();
      await secureStorage.deleteAll();
    }
  }

  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<void> _initializeEnvironment() async {
    await dotenv.load(fileName: ConfigKeys.fileName);
  }

  static Future<void> _initializeStripe() async {
    final publishableKey = AppConfig.stripePublishableKey.trim();
    if (!publishableKey.startsWith('pk_')) {
      throw StateError('A valid Stripe publishable key is required.');
    }
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
    if (kDebugMode) {
      debugPrint('[Stripe] SDK settings applied');
    }
  }

  static Future<void> _initializeBlocObserver() async {
    Bloc.observer = MyBlocObserver();
  }

  static void _configureErrorHandling() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      return true;
    };
  }
}
