import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'config/app_preferences/app_preferences.dart';
import 'config/language/app_language_info.dart';
import 'config/routes/app_router.dart';
import 'core/storage/shared_storage.dart';
import 'core/storage/storage_data.dart';
import 'features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'features/notification/domain/usecases/update_fcm_token_usecase.dart';
import 'features/notification/presentation/bloc/notification_bloc.dart';
import 'features/complaints/presentation/bloc/complaints_bloc.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background notification received');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  bool _isPushNotificationsInitialized = false;
  bool _isTokenRefreshListenerRegistered = false;
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notification',
    importance: Importance.max,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null || !_notificationsEnabled) return;

    final type = message.data['type']?.toString();
    final notificationId = int.tryParse(
      message.data['notification_id']?.toString() ?? '',
    );
    final orderId = int.tryParse(message.data['order_id']?.toString() ?? '');
    final complaintId = int.tryParse(
      message.data['complaint_id']?.toString() ?? '',
    );

    if (GetIt.I.isRegistered<NotificationsBloc>()) {
      GetIt.I<NotificationsBloc>().add(
        NotificationTappedFromPushEvent(
          notificationId: notificationId,
          orderId: orderId,
          complaintId: complaintId,
          type: type,
        ),
      );
      return;
    }

    if (notificationId != null &&
        GetIt.I.isRegistered<MarkNotificationAsReadUseCase>()) {
      unawaited(_markPushNotificationAsRead(notificationId));
    }

    if (type == 'complaint_response' && complaintId != null) {
      unawaited(
        AppRouter.openComplaintDetailsFromExternalNotification(complaintId),
      );
    } else if (orderId != null) {
      unawaited(AppRouter.openOrderDetailsFromExternalNotification(orderId));
    }
  }

  Future<void> _markPushNotificationAsRead(int notificationId) async {
    try {
      await GetIt.I<MarkNotificationAsReadUseCase>()(
        MarkNotificationAsReadParams(notificationId: notificationId),
      );
    } catch (e) {
      debugPrint('Failed to mark push notification as read: $e');
    }
  }

  Future<void> initLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotification.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) {
        if (!_notificationsEnabled) return;
        if (payload.payload != null) {
          try {
            final decodedPayload = jsonDecode(payload.payload!);
            if (decodedPayload is Map<String, dynamic>) {
              handleMessage(RemoteMessage.fromMap(decodedPayload));
            }
          } catch (e) {
            debugPrint('Failed to read notification payload: $e');
          }
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
    if (_isPushNotificationsInitialized) return;
    _isPushNotificationsInitialized = true;

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      if (!_notificationsEnabled) return;
      debugPrint("Foreground message received");
      if (GetIt.I.isRegistered<NotificationsBloc>()) {
        GetIt.I<NotificationsBloc>().add(const NewNotificationReceivedEvent());
      }
      if (message.data['type']?.toString() == 'complaint_response' &&
          GetIt.I.isRegistered<ComplaintsBloc>()) {
        GetIt.I<ComplaintsBloc>().add(const LoadComplaintUnreadCountEvent());
      }
      final notification = message.notification;
      final title =
          notification?.title ??
          message.data['title']?.toString() ??
          'CleanLink';
      final body =
          notification?.body ??
          message.data['body']?.toString() ??
          'You have a new update.';

      _localNotification.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotifications() async {
    debugPrint('initNotifications started');

    if (_isInitialized) {
      debugPrint('initNotifications skipped');
      return;
    }

    _isInitialized = true;

    final hasSavedPreference = await SharedStorage.hasData(
      StorageData.pushNotifications,
    );
    var settings = await _firebaseMessaging.getNotificationSettings();
    if (hasSavedPreference) {
      _notificationsEnabled =
          await SharedStorage.getBool(StorageData.pushNotifications) ?? true;
    } else {
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        settings = await _requestPermission();
      }
      _notificationsEnabled = _isAuthorized(settings.authorizationStatus);
      await SharedStorage.set(
        StorageData.pushNotifications,
        _notificationsEnabled,
      );
    }

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    await initLocalNotifications();

    await initPushNotifications();

    if (_notificationsEnabled) await cacheCurrentFcmToken();

    listenToTokenRefresh();

    debugPrint('initNotifications finished');
  }

  Future<NotificationSettings> _requestPermission() {
    return _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  bool _isAuthorized(AuthorizationStatus status) =>
      status == AuthorizationStatus.authorized ||
      status == AuthorizationStatus.provisional;

  Future<NotificationPreferenceResult> enableNotifications() async {
    var settings = await _firebaseMessaging.getNotificationSettings();
    if (!_isAuthorized(settings.authorizationStatus)) {
      settings = await _requestPermission();
    }
    if (!_isAuthorized(settings.authorizationStatus)) {
      _notificationsEnabled = false;
      await SharedStorage.set(StorageData.pushNotifications, false);
      final permission = await permissions.Permission.notification.status;
      return NotificationPreferenceResult(
        enabled: false,
        permissionStatus: permission.isPermanentlyDenied
            ? NotificationPermissionStatus.permanentlyDenied
            : NotificationPermissionStatus.denied,
      );
    }

    _notificationsEnabled = true;
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await cacheCurrentFcmToken();
    final synced = await syncFcmTokenWithBackend();
    if (!synced) {
      _notificationsEnabled = false;
      await SharedStorage.set(StorageData.pushNotifications, false);
      return const NotificationPreferenceResult(
        enabled: false,
        permissionStatus: NotificationPermissionStatus.authorized,
        syncFailed: true,
      );
    }
    await SharedStorage.set(StorageData.pushNotifications, true);
    return const NotificationPreferenceResult(
      enabled: true,
      permissionStatus: NotificationPermissionStatus.authorized,
    );
  }

  Future<void> disableNotifications() async {
    _notificationsEnabled = false;
    await SharedStorage.set(StorageData.pushNotifications, false);
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
    await _localNotification.cancelAll();
    try {
      await _firebaseMessaging.deleteToken();
      await SharedStorage.delete(StorageData.fcmToken);
    } catch (error) {
      debugPrint('Could not invalidate the FCM token: $error');
    }
  }

  Future<bool> openNotificationSettings() => permissions.openAppSettings();

  Future<void> cacheCurrentFcmToken() async {
    if (!_notificationsEnabled) return;
    try {
      debugPrint('cacheCurrentFcmToken started');

      final currentToken = await _firebaseMessaging.getToken();

      if (currentToken == null || currentToken.isEmpty) {
        debugPrint('Failed to get FCM token');
        return;
      }

      final savedToken = await SharedStorage.get<String>(StorageData.fcmToken);

      if (savedToken != currentToken) {
        await AppPreferences.setDeviceToken(currentToken);
        debugPrint('FCM token updated locally.');
      } else {
        debugPrint('FCM token already cached.');
      }
    } catch (_) {
      debugPrint('Failed to cache FCM token.');
    }
  }

  Future<bool> syncFcmTokenWithBackend() async {
    try {
      if (!_notificationsEnabled) {
        debugPrint('Notifications disabled. Skip FCM token sync.');
        return true;
      }
      final authToken = await SharedStorage.get<String>(StorageData.token);

      if (authToken == null || authToken.isEmpty) {
        debugPrint('User is not logged in. Skip FCM token sync.');
        return true;
      }

      final currentToken = await _firebaseMessaging.getToken();

      if (currentToken == null || currentToken.isEmpty) {
        debugPrint('FCM token is empty. Skip backend sync.');
        return false;
      }

      await AppPreferences.setDeviceToken(currentToken);

      if (!GetIt.I.isRegistered<UpdateFcmTokenUseCase>()) {
        debugPrint('UpdateFcmTokenUseCase is not registered.');
        return false;
      }

      await GetIt.I<UpdateFcmTokenUseCase>()(
        UpdateFcmTokenParams(
          fcmToken: currentToken,
          deviceType: getDeviceType(),
          lang: AppLanguageInfo.languageCode,
        ),
      );

      debugPrint('FCM token synced with backend.');
      return true;
    } catch (_) {
      debugPrint('Failed to sync FCM token with backend.');
      return false;
    }
  }

  String getDeviceType() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  void listenToTokenRefresh() {
    if (_isTokenRefreshListenerRegistered) return;
    _isTokenRefreshListenerRegistered = true;

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (!_notificationsEnabled) return;
      debugPrint('FCM token refreshed.');

      await AppPreferences.setDeviceToken(newToken);

      final authToken = await SharedStorage.get<String>(StorageData.token);

      if (authToken == null || authToken.isEmpty) {
        debugPrint('User is not logged in. Token saved locally only.');
        return;
      }

      try {
        if (!GetIt.I.isRegistered<UpdateFcmTokenUseCase>()) {
          debugPrint('UpdateFcmTokenUseCase is not registered.');
          return;
        }

        await GetIt.I<UpdateFcmTokenUseCase>()(
          UpdateFcmTokenParams(
            fcmToken: newToken,
            deviceType: getDeviceType(),
            lang: AppLanguageInfo.languageCode,
          ),
        );

        debugPrint('Refreshed FCM token synced with backend.');
      } catch (_) {
        debugPrint('Failed to sync refreshed FCM token.');
      }
    });
  }
}

enum NotificationPermissionStatus { authorized, denied, permanentlyDenied }

class NotificationPreferenceResult {
  const NotificationPreferenceResult({
    required this.enabled,
    required this.permissionStatus,
    this.syncFailed = false,
  });

  final bool enabled;
  final NotificationPermissionStatus permissionStatus;
  final bool syncFailed;
}
