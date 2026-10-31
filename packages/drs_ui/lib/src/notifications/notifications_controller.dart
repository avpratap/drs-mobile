import 'dart:async';

import 'package:drs_core/drs_core.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'push_platform.dart';

/// Backend calls for device tokens (apps wire these to drs_api).
class PushTokenApi {
  const PushTokenApi({required this.register, required this.unregister});

  final Future<void> Function(String token, String platform) register;
  final Future<void> Function(String token) unregister;
}

// Dependencies — each app overrides these in its root ProviderScope. The
// defaults make notifications a safe no-op (tests, builds without Firebase).
final pushPlatformProvider = Provider<PushPlatform>(
  (_) => const DisabledPushPlatform(),
);
final pushPrefsProvider = Provider<PushPrefs>((_) => InMemoryPushPrefs());
final pushTokenApiProvider = Provider<PushTokenApi?>((_) => null);
final pushRouteResolverProvider = Provider<PushRouteResolver>(
  (_) =>
      (_) => null,
);

/// Whether a user session exists (apps bind this to their auth state).
final pushSignedInProvider = Provider<bool>((_) => false);

@immutable
class NotificationsState {
  const NotificationsState({
    this.started = false,
    this.available = false,
    this.permission = PushPermission.notDetermined,
    this.consent,
    this.registered = false,
    this.pendingRoute,
    this.lastForeground,
  });

  final bool started;
  final bool available;
  final PushPermission permission;

  /// null = never asked, true = opted in, false = opted out.
  final bool? consent;

  /// The device token is registered with the backend.
  final bool registered;

  /// Where a tapped notification wants to go ('' = just open the app).
  final String? pendingRoute;
  final PushPayload? lastForeground;

  bool get enabled => consent == true && permission.canReceive;

  /// Offer the in-app opt-in card (before ever showing the OS prompt).
  bool get shouldOfferOptIn =>
      available && consent == null && permission != PushPermission.denied;

  NotificationsState copyWith({
    bool? started,
    bool? available,
    PushPermission? permission,
    bool? consent,
    bool clearConsent = false,
    bool? registered,
    String? pendingRoute,
    bool clearRoute = false,
    PushPayload? lastForeground,
  }) => NotificationsState(
    started: started ?? this.started,
    available: available ?? this.available,
    permission: permission ?? this.permission,
    consent: clearConsent ? null : (consent ?? this.consent),
    registered: registered ?? this.registered,
    pendingRoute: clearRoute ? null : (pendingRoute ?? this.pendingRoute),
    lastForeground: lastForeground ?? this.lastForeground,
  );
}

/// One notifications service for every DRS app: consent, OS permission,
/// token registration (via [DeviceTokenRegistrar]) and tap routing.
class NotificationsController extends Notifier<NotificationsState> {
  final _subs = <StreamSubscription<Object?>>[];

  PushPlatform get _platform => ref.read(pushPlatformProvider);
  PushPrefs get _prefs => ref.read(pushPrefsProvider);

  DeviceTokenRegistrar? get _registrar {
    final api = ref.read(pushTokenApiProvider);
    if (api == null) return null;
    return DeviceTokenRegistrar(
      register: api.register,
      unregister: api.unregister,
      prefs: _prefs,
      platform: _platform.platformName,
    );
  }

  @override
  NotificationsState build() {
    ref
      ..listen(pushSignedInProvider, (_, signedIn) {
        if (signedIn) unawaited(_refreshAndSync());
      })
      ..onDispose(() {
        for (final s in _subs) {
          unawaited(s.cancel());
        }
      });
    return const NotificationsState();
  }

  /// Initialises the platform and handles a launch-from-notification. Safe
  /// to call more than once.
  Future<void> start() async {
    if (state.started) return;
    state = state.copyWith(started: true);
    final p = _platform;
    if (!p.available) return;
    try {
      await p.init();
    } on Object {
      return; // Misconfigured Firebase: stay disabled rather than crash.
    }
    _subs
      ..add(p.opened.listen(_open))
      ..add(
        p.foreground.listen(
          (m) => state = state.copyWith(
            lastForeground: PushPayload.fromData(m.data),
          ),
        ),
      )
      ..add(p.tokenRefresh.listen((_) => unawaited(_sync())));
    state = state.copyWith(
      available: true,
      permission: await p.permission(),
      consent: await _prefs.consent(),
    );
    final initial = await p.initialOpen();
    if (initial != null) _open(initial);
    await _sync();
  }

  /// In-app opt-in, then the OS prompt. A denial is respected: the app keeps
  /// working and the settings tile explains how to re-enable.
  Future<void> enable() async {
    await _prefs.setConsent(true);
    final permission = state.available
        ? await _platform.requestPermission()
        : PushPermission.unsupported;
    state = state.copyWith(consent: true, permission: permission);
    await _sync();
  }

  /// Opt-out: deactivate on the backend and invalidate the device token.
  Future<void> disable() async {
    await _prefs.setConsent(false);
    state = state.copyWith(consent: false);
    await _sync();
    if (state.available) {
      try {
        await _platform.deleteToken();
      } on Object {
        // Best effort.
      }
    }
  }

  /// Call BEFORE revoking the session (unregister needs a valid token).
  Future<void> signOut() async {
    await _registrar?.signOut();
    state = state.copyWith(
      clearConsent: true,
      registered: false,
      clearRoute: true,
    );
  }

  /// The app navigated to [NotificationsState.pendingRoute].
  void consumeRoute() => state = state.copyWith(clearRoute: true);

  void _open(Map<String, Object?> data) {
    final route = ref.read(pushRouteResolverProvider)(
      PushPayload.fromData(data),
    );
    state = state.copyWith(pendingRoute: route ?? '');
  }

  Future<void> _refreshAndSync() async {
    if (state.available) {
      state = state.copyWith(
        permission: await _platform.permission(),
        consent: await _prefs.consent(),
      );
    }
    await _sync();
  }

  Future<void> _sync() async {
    final registrar = _registrar;
    if (registrar == null) return;
    final token = state.available && state.permission.canReceive
        ? await _platform.token()
        : null;
    await registrar.sync(
      signedIn: ref.read(pushSignedInProvider),
      token: token,
    );
    if (!ref.mounted) return;
    state = state.copyWith(registered: await _prefs.registeredToken() != null);
  }
}

final notificationsControllerProvider =
    NotifierProvider<NotificationsController, NotificationsState>(
      NotificationsController.new,
    );
