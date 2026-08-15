
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/api_config.dart';
import 'injection_container.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Resolves the API host (emulator alias / localhost / LAN IP) exactly once,
  // BEFORE anything can build an HTTP client from it. Device detection is
  // async, so it has to be awaited here — every later read is synchronous.
  await ApiConfig.init();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initializeDependencies();

  await NotificationService.instance.init();

  runApp(MyApp());
}
