import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'config/app_preferences/app_preferences.dart';
import 'core/storage/shared_storage.dart';
import 'core/storage/storage_data.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Background notification received');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notification',
    importance: Importance.max,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigation logic
  }

  Future<void> initLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotification.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) {
        if (payload.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
          handleMessage(message);
        }
      },
    );

    final platform = _localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Foreground message received");
      final notification = message.notification;
      if (notification == null) return;

      _localNotification.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
      'User granted notifications permission: ${settings.authorizationStatus}',
    );

    try {
      if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          debugPrint("APNs Token: $apnsToken");
        } else {
          debugPrint("APNs Token is not yet available");
        }
      }

      if (!await SharedStorage.hasData(StorageData.fcmToken)) {
        await _firebaseMessaging.getToken().then((String? token) async {
          if (token != null) {
            debugPrint("FCM Token (new): $token");
            await AppPreferences.setDeviceToken(token);
            print(await SharedStorage.get(StorageData.fcmToken));
          } else {
            debugPrint("Failed to get FCM token");
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    await initLocalNotifications();
    await initPushNotifications();

    listenToTokenRefresh();
  }

  void listenToTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("FCM Token refreshed: $newToken");

      await AppPreferences.setDeviceToken(newToken);

      /// 🔥 SEND TO BACKEND
      /// POST /user/fcm-token
      /// { token: newToken }
    });
  }
}
