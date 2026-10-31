import 'dart:async';
import 'dart:convert';

import 'package:drs_core/drs_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'push_platform.dart';

/// Firebase options from `--dart-define` values (no google-services.json /
/// GoogleService-Info.plist in the repo). Null when not configured.
FirebaseOptions? drsFirebaseOptions(DrsEnv env, {required bool ios}) {
  if (!env.hasFirebase(ios: ios)) return null;
  return FirebaseOptions(
    apiKey: env.firebaseApiKey,
    appId: env.firebaseAppId(ios: ios),
    messagingSenderId: env.fcmSenderId,
    projectId: env.firebaseProjectId,
  );
}

bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;

/// Runs in a background isolate for messages received while the app is in
/// the background / terminated. Notification messages are displayed by the
/// OS; this only initialises Firebase so the plugin can run. Must be a
/// top-level function.
@pragma('vm:entry-point')
Future<void> drsPushBackgroundHandler(RemoteMessage message) async {
  final options = drsFirebaseOptions(DrsEnv.fromEnvironment(), ios: _isIos);
  if (options != null && Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: options);
  }
}

/// FCM + local notifications (Android shows foreground pushes through a
/// local notification; iOS presents them natively).
class FirebasePushPlatform implements PushPlatform {
  FirebasePushPlatform(this._options);

  final FirebaseOptions _options;
  final _local = FlutterLocalNotificationsPlugin();
  final _opened = StreamController<Map<String, Object?>>.broadcast();
  final _foreground = StreamController<PushMessage>.broadcast();

  static const _channel = AndroidNotificationChannel(
    'drs_default',
    'Orders & deliveries',
    description: 'Order, delivery, subscription and wallet updates',
    importance: Importance.high,
  );

  FirebaseMessaging get _fm => FirebaseMessaging.instance;

  @override
  bool get available => true;

  @override
  String get platformName => _isIos ? 'ios' : 'android';

  @override
  Future<void> init() async {
    if (Firebase.apps.isEmpty) await Firebase.initializeApp(options: _options);
    FirebaseMessaging.onBackgroundMessage(drsPushBackgroundHandler);
    // Permission is requested explicitly after in-app consent, never at launch.
    await _fm.setAutoInitEnabled(true);
    if (_isIos) {
      await _fm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final data = _decode(r.payload);
        if (data != null) _opened.add(data);
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen((m) {
      final msg = PushMessage(
        title: m.notification?.title,
        body: m.notification?.body,
        data: m.data,
      );
      _foreground.add(msg);
      if (!_isIos && (msg.title != null || msg.body != null)) {
        unawaited(
          _local.show(
            id: m.hashCode & 0x7fffffff,
            title: msg.title,
            body: msg.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
            payload: jsonEncode(m.data),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _opened.add(m.data));
  }

  static Map<String, Object?>? _decode(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      return (jsonDecode(payload) as Map).cast<String, Object?>();
    } on Object {
      return null;
    }
  }

  static PushPermission _map(AuthorizationStatus s) => switch (s) {
    AuthorizationStatus.authorized => PushPermission.granted,
    AuthorizationStatus.provisional => PushPermission.provisional,
    AuthorizationStatus.denied ||
    // Android 13+: only system settings can re-enable.
    AuthorizationStatus.deniedPermanently => PushPermission.denied,
    AuthorizationStatus.notDetermined => PushPermission.notDetermined,
  };

  @override
  Future<PushPermission> permission() async =>
      _map((await _fm.getNotificationSettings()).authorizationStatus);

  @override
  Future<PushPermission> requestPermission() async =>
      _map((await _fm.requestPermission()).authorizationStatus);

  @override
  Future<String?> token() async {
    try {
      // iOS: no FCM token until APNs has issued one (needs the Push
      // Notifications capability + APNs key in Firebase).
      if (_isIos && await _fm.getAPNSToken() == null) return null;
      // Deliberately the classic FCM registration token, not the newer FID
      // (register()/onRegistered): the DRS backend sends with FCM HTTP v1
      // `message.token` and validates token length >= 64, which an FID fails.
      // Migrate both sides together (noted for the backend).
      // ignore: deprecated_member_use
      return await _fm.getToken();
    } on Object {
      return null;
    }
  }

  @override
  // ignore: deprecated_member_use
  Stream<String> get tokenRefresh => _fm.onTokenRefresh; // see token()

  @override
  Stream<PushMessage> get foreground => _foreground.stream;

  @override
  Stream<Map<String, Object?>> get opened => _opened.stream;

  @override
  Future<Map<String, Object?>?> initialOpen() async {
    final remote = await _fm.getInitialMessage();
    if (remote != null) return remote.data;
    final launch = await _local.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      return _decode(launch!.notificationResponse?.payload);
    }
    return null;
  }

  @override
  // ignore: deprecated_member_use
  Future<void> deleteToken() => _fm.deleteToken(); // see token()
}
