import 'dart:async';

import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

class FakePushPlatform implements PushPlatform {
  FakePushPlatform({this.grant = PushPermission.granted});

  PushPermission grant;
  PushPermission current = PushPermission.notDetermined;
  String? currentToken = 't' * 160;
  Map<String, Object?>? launchedWith;
  int prompts = 0;
  int deletes = 0;
  final openedCtl = StreamController<Map<String, Object?>>.broadcast();
  final refreshCtl = StreamController<String>.broadcast();
  final fgCtl = StreamController<PushMessage>.broadcast();

  @override
  bool get available => true;
  @override
  String get platformName => 'ios';
  @override
  Future<void> init() async {}
  @override
  Future<PushPermission> permission() async => current;
  @override
  Future<PushPermission> requestPermission() async {
    prompts++;
    return current = grant;
  }

  @override
  Future<String?> token() async => currentToken;
  @override
  Stream<String> get tokenRefresh => refreshCtl.stream;
  @override
  Stream<PushMessage> get foreground => fgCtl.stream;
  @override
  Stream<Map<String, Object?>> get opened => openedCtl.stream;
  @override
  Future<Map<String, Object?>?> initialOpen() async => launchedWith;
  @override
  Future<void> deleteToken() async => deletes++;
}

void main() {
  late FakePushPlatform platform;
  late List<String> api;
  late InMemoryPushPrefs prefs;
  late ProviderContainer c;
  var signedIn = false;
  final signedInProvider = StateProvider<bool>((_) => signedIn);

  ProviderContainer make() => ProviderContainer(
    overrides: [
      pushPlatformProvider.overrideWithValue(platform),
      pushPrefsProvider.overrideWithValue(prefs),
      pushTokenApiProvider.overrideWithValue(
        PushTokenApi(
          register: (t, p) async => api.add('register ${t.substring(0, 1)} $p'),
          unregister: (t) async => api.add('unregister ${t.substring(0, 1)}'),
        ),
      ),
      pushSignedInProvider.overrideWith((ref) => ref.watch(signedInProvider)),
      pushRouteResolverProvider.overrideWithValue(
        (p) => p.orderId == null ? null : '/orders/${p.orderId}',
      ),
    ],
  );

  NotificationsController ctl() =>
      c.read(notificationsControllerProvider.notifier);
  NotificationsState state() => c.read(notificationsControllerProvider);

  setUp(() {
    platform = FakePushPlatform();
    api = [];
    prefs = InMemoryPushPrefs();
    signedIn = false;
    c = make();
    addTearDown(c.dispose);
    // Riverpod 3 pauses providers nobody listens to (apps watch it from the
    // root widget); keep it active like the app does.
    c.listen(notificationsControllerProvider, (_, _) {});
  });

  test('never prompts at launch; offers the in-app opt-in first', () async {
    await ctl().start();
    expect(platform.prompts, 0);
    expect(state().shouldOfferOptIn, isTrue);
    expect(api, isEmpty);
  });

  test('opt-in → OS prompt → token registered once signed in', () async {
    await ctl().start();
    await ctl().enable(); // before sign-in: nothing registered yet
    expect(platform.prompts, 1);
    expect(api, isEmpty);

    c.read(signedInProvider.notifier).state = true;
    await pumpEventQueue();
    expect(api, ['register t ios']);
    expect(state().registered, isTrue);
    expect(state().enabled, isTrue);
  });

  test(
    'denied permission is handled: no registration, explained state',
    () async {
      platform.grant = PushPermission.denied;
      c.read(signedInProvider.notifier).state = true;
      await ctl().start();
      await ctl().enable();
      expect(api, isEmpty);
      expect(state().consent, isTrue);
      expect(state().permission, PushPermission.denied);
      expect(state().enabled, isFalse);
      expect(state().shouldOfferOptIn, isFalse);
    },
  );

  test('token refresh rotates the registration; opt-out unregisters', () async {
    c.read(signedInProvider.notifier).state = true;
    await ctl().start();
    await ctl().enable();
    platform.currentToken = 'u' * 160;
    platform.refreshCtl.add(platform.currentToken!);
    await pumpEventQueue();
    expect(api, ['register t ios', 'unregister t', 'register u ios']);

    await ctl().disable();
    expect(api.last, 'unregister u');
    expect(platform.deletes, 1);
    expect(state().registered, isFalse);
  });

  test(
    'sign-out unregisters (session still valid) and forgets consent',
    () async {
      c.read(signedInProvider.notifier).state = true;
      await ctl().start();
      await ctl().enable();
      await ctl().signOut();
      expect(api.last, 'unregister t');
      expect(await prefs.consent(), isNull);
      expect(state().consent, isNull);
    },
  );

  test(
    'tap while running and cold-start launch both produce a route',
    () async {
      platform.launchedWith = {'type': 'order.delivered', 'order_id': '7'};
      await ctl().start();
      expect(state().pendingRoute, '/orders/7');
      ctl().consumeRoute();
      expect(state().pendingRoute, isNull);

      platform.openedCtl.add({'type': 'promo'}); // resolver returns null
      await pumpEventQueue();
      expect(state().pendingRoute, ''); // just open the app
    },
  );

  test('disabled platform is a safe no-op', () async {
    final c2 = ProviderContainer();
    addTearDown(c2.dispose);
    await c2.read(notificationsControllerProvider.notifier).start();
    await c2.read(notificationsControllerProvider.notifier).enable();
    final s = c2.read(notificationsControllerProvider);
    expect(s.available, isFalse);
    expect(s.shouldOfferOptIn, isFalse);
  });
}
