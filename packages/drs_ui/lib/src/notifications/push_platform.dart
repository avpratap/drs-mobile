import 'dart:async';

/// OS notification permission, normalised across iOS and Android.
enum PushPermission {
  granted,

  /// iOS provisional (quiet) delivery.
  provisional,
  denied,
  notDetermined,

  /// Push isn't configured in this build (no Firebase values).
  unsupported;

  bool get canReceive => this == granted || this == provisional;
}

/// A message received while the app is in the foreground.
class PushMessage {
  const PushMessage({this.title, this.body, this.data = const {}});

  final String? title;
  final String? body;
  final Map<String, Object?> data;
}

/// The notification capabilities the app relies on. The Firebase
/// implementation is used when configured; otherwise [DisabledPushPlatform].
abstract interface class PushPlatform {
  bool get available;

  /// `ios` | `android` (the backend's device-token platform values).
  String get platformName;

  Future<void> init();
  Future<PushPermission> permission();

  /// Shows the OS prompt (iOS APNs alert; Android 13+ POST_NOTIFICATIONS).
  Future<PushPermission> requestPermission();

  /// The FCM token, or null when unavailable (e.g. APNs not set up).
  Future<String?> token();
  Stream<String> get tokenRefresh;
  Stream<PushMessage> get foreground;

  /// Data of notifications the user tapped while the app was running.
  Stream<Map<String, Object?>> get opened;

  /// Data of the notification that launched the app from terminated state.
  Future<Map<String, Object?>?> initialOpen();

  /// Invalidates this install's token (used on opt-out).
  Future<void> deleteToken();
}

/// No-op platform for builds without Firebase config (CI, local dev, tests).
class DisabledPushPlatform implements PushPlatform {
  const DisabledPushPlatform([this.platformName = 'android']);

  @override
  final String platformName;

  @override
  bool get available => false;

  @override
  Future<void> init() async {}

  @override
  Future<PushPermission> permission() async => PushPermission.unsupported;

  @override
  Future<PushPermission> requestPermission() async =>
      PushPermission.unsupported;

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefresh => const Stream.empty();

  @override
  Stream<PushMessage> get foreground => const Stream.empty();

  @override
  Stream<Map<String, Object?>> get opened => const Stream.empty();

  @override
  Future<Map<String, Object?>?> initialOpen() async => null;

  @override
  Future<void> deleteToken() async {}
}
