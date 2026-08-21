import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../config/constants/api_url_parameters.dart';
import '../config/language/app_language_info.dart';
import '../config/routes/app_router.dart';
import '../core/session/login_session.dart';
import '../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../features/tasks/presentation/utils/open_task.dart';
import '../injection_container.dart';

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'Task notifications',
  description: 'Notifications about tasks assigned to you.',
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  final Set<String> _markedRead = <String>{};

  final StreamController<void> _pushReceived =
      StreamController<void>.broadcast();

  Stream<void> get onPushReceived => _pushReceived.stream;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: androidInit,
          iOS: iosInit,
        ),

        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      await _messaging.requestPermission();

      _messaging.getToken().then((t) => log('FCM token: $t')).catchError((
        Object e,
      ) {
        log('FCM getToken failed: $e');
        return null;
      });

      _messaging.onTokenRefresh.listen((_) => registerToken());

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _handleNotificationTap(message.data),
      );

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage.data);
      }
    } catch (e) {
      log('NotificationService.init failed: $e');
    }
  }

  Future<void> registerToken() async {
    if (!LoginSession.hasToken) return;

    try {
      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 15),
        onTimeout: () => null,
      );
      if (token == null || token.isEmpty) return;

      if (!LoginSession.hasToken) return;

      await sl<Dio>().post(
        ApiUrlParameters.fcmToken,
        data: {
          'fcm_token': token,
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'lang': AppLanguageInfo.languageCode,
        },
        options: Options(extra: const {kSkipAuthRedirect: true}),
      );
    } catch (e) {
      log('NotificationService.registerToken failed: $e');
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (!_pushReceived.isClosed) _pushReceived.add(null);
    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),

      payload: jsonEncode(message.data),
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
      _handleNotificationTap(data);
    } catch (e) {
      log('NotificationService: bad notification payload: $e');
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final notificationId = data['notification_id']?.toString();
    if (notificationId != null && notificationId.isNotEmpty) {
      _markAsRead(notificationId);
    }
    final orderId = data['order_id']?.toString();
    if (orderId != null && orderId.isNotEmpty) {
      openTaskFromNotification(orderId);
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    if (!_markedRead.add(notificationId)) return;
    try {
      final result = await sl<MarkNotificationReadUseCase>()(
        params: notificationId,
      );
      result.fold(
        (failure) => log('mark-as-read failed: ${failure.message}'),
        (_) {},
      );
    } catch (e) {
      log('mark-as-read threw: $e');
    }
  }

  void openTaskFromNotification(String orderId) {
    _whenNavigatorReady(() {
      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context == null) return;
      openTaskById(context, orderId);
    });
  }

  void _whenNavigatorReady(VoidCallback action, [int attempt = 0]) {
    if (AppRouter.rootNavigatorKey.currentState != null) {
      action();
      return;
    }
    if (attempt >= 20) return;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _whenNavigatorReady(action, attempt + 1),
    );
  }
}
