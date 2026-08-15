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

/// Android channel used both for the runtime local notifications shown while
/// the app is in the foreground and, via the Manifest meta-data, as FCM's
/// default channel for background/terminated messages. The id MUST match the
/// `default_notification_channel_id` meta-data in AndroidManifest.xml.
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'Task notifications',
  description: 'Notifications about tasks assigned to you.',
  importance: Importance.high,
);

/// Top-level background handler — required by FCM to be a static/top-level
/// function with `@pragma('vm:entry-point')` so it survives tree-shaking and
/// can run in its own isolate. The backend sends notification-type messages,
/// so the OS renders them in the system tray automatically; this only needs a
/// live Firebase app in the background isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// Self-contained push-notification layer. Everything FCM-related lives here so
/// the rest of the app only ever touches [NotificationService.instance].
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Notification ids already marked read this session, so a double-tap never
  /// fires the mark-as-read request twice.
  final Set<String> _markedRead = <String>{};

  /// Broadcasts each time a push arrives while the app is running (foreground).
  /// The badge's `NotificationsBloc` listens and refetches so the unread count
  /// updates the instant the message lands. App-lifetime (singleton) — never
  /// closed.
  final StreamController<void> _pushReceived =
      StreamController<void>.broadcast();

  /// Fires on every foreground push. Subscribe to keep the unread badge live.
  Stream<void> get onPushReceived => _pushReceived.stream;

  /// Wires up permissions, the local-notification channel and the foreground
  /// message listener. Safe to call once at startup; never throws.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Local notifications (used to render FCM messages while in foreground —
      // FCM shows nothing itself when the app is open).
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: androidInit,
          iOS: iosInit,
        ),
        // Foreground notifications are shown by us as local ones; this fires
        // when the worker taps one, carrying the FCM data as the payload.
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      // Ask the user (Android 13+ / iOS) for notification permission.
      await _messaging.requestPermission();

      // Print the token so it can be copied for a test push (harmless in debug).
      _messaging.getToken().then((t) => log('FCM token: $t')).catchError(
        (Object e) {
          log('FCM getToken failed: $e');
          return null;
        },
      );

      // Re-register whenever FCM rotates the token.
      _messaging.onTokenRefresh.listen((_) => registerToken());

      // Foreground messages: FCM stays silent, so we surface a local one and
      // signal the badge to refetch.
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      // Background (app alive but not foreground): the OS shows the tray
      // notification; tapping it brings the app forward with the message.
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _handleNotificationTap(message.data),
      );

      // Terminated (cold start from a notification): the message that launched
      // the app. Routed once the navigator is ready (see openTaskFromNotification).
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage.data);
      }
    } catch (e) {
      log('NotificationService.init failed: $e');
    }
  }

  /// Fetches the current FCM token and sends it to the backend for the
  /// signed-in worker. Called on every login and on language change. No-ops
  /// (never throws) when there is no auth token, no FCM token, or the network
  /// is unreachable — a failure here must never break the app.
  ///
  /// This runs in the background right after a successful login. On a FIRST run
  /// `getToken()` has to register the device with FCM before it can answer,
  /// which is slow — so both the token fetch and the POST are treated as
  /// strictly best-effort:
  ///  - the fetch is bounded by its own timeout, so it can never hang;
  ///  - the POST opts out of the interceptor's auth redirect
  ///    ([kSkipAuthRedirect]), so a slow/failed background call can never throw
  ///    the worker who just logged in back to the Login screen.
  Future<void> registerToken() async {
    // The endpoint is authenticated; without a bearer token there is nobody to
    // register the device against yet (it will be sent right after login).
    if (!LoginSession.hasToken) return;

    try {
      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 15),
        onTimeout: () => null,
      );
      if (token == null || token.isEmpty) return;

      // Re-check: the worker may have logged out while FCM was answering.
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
      // Swallow: token may be null, or the server may be unreachable.
      log('NotificationService.registerToken failed: $e');
    }
  }

  /// Foreground message: signal the badge to refetch (live unread count), then
  /// surface the message as a local notification.
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (!_pushReceived.isClosed) _pushReceived.add(null);
    await _showLocalNotification(message);
  }

  /// Renders a foreground [message] as a local notification so the worker sees
  /// it even while the app is open.
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
      // Carry the FCM data so the tap handler can route + mark read.
      payload: jsonEncode(message.data),
    );
  }

  /// Tap on a foreground local notification: decode the payload we stored above
  /// and route the same way a background/terminated tap does.
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

  /// Shared tap handler for the FCM states (foreground/background/terminated).
  /// Marks the notification read (via `notification_id`) and opens the assigned
  /// task's detail (via `order_id`). Mark-as-read never blocks the navigation.
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

  /// Calls the existing mark-as-read API. Idempotent across taps (guarded by
  /// [_markedRead]) and never throws — a failure is logged, not surfaced.
  Future<void> _markAsRead(String notificationId) async {
    if (!_markedRead.add(notificationId)) return; // already marked this session
    try {
      final result =
          await sl<MarkNotificationReadUseCase>()(params: notificationId);
      result.fold(
        (failure) => log('mark-as-read failed: ${failure.message}'),
        (_) {},
      );
    } catch (e) {
      log('mark-as-read threw: $e');
    }
  }

  /// The single destination for any notification tap — FCM or in-app: the
  /// assigned task's detail screen, resolved from [orderId]. Waits until the
  /// navigator is mounted, so the terminated cold-start case (handled before
  /// the first frame) routes as soon as the app is ready.
  void openTaskFromNotification(String orderId) {
    _whenNavigatorReady(() {
      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context == null) return;
      openTaskById(context, orderId);
    });
  }

  /// Runs [action] as soon as the root navigator exists, retrying briefly.
  /// Gives up after ~10s so a stuck launch can never leak a periodic timer.
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
