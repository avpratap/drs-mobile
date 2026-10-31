import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late FakePushPlatform platform;
  late List<String> api;
  late InMemoryPushPrefs prefs;
  late ProviderContainer c;

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

    await ctl().setSignedIn(true);
    expect(api, ['register t ios']);
    expect(state().registered, isTrue);
    expect(state().enabled, isTrue);
  });

  test(
    'denied permission is handled: no registration, explained state',
    () async {
      platform.grant = PushPermission.denied;
      await ctl().setSignedIn(true);
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
    await ctl().setSignedIn(true);
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
      await ctl().setSignedIn(true);
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

  test(
    'a token that is not available yet never unregisters a valid one',
    () async {
      await ctl().setSignedIn(true);
      await ctl().start();
      await ctl().enable();
      expect(api, ['register t ios']);
      // Next launch: iOS hasn't produced the APNs/FCM token yet.
      platform.currentToken = null;
      final c2 = make();
      addTearDown(c2.dispose);
      c2.listen(notificationsControllerProvider, (_, _) {});
      await c2.read(notificationsControllerProvider.notifier).setSignedIn(true);
      await c2.read(notificationsControllerProvider.notifier).start();
      expect(api, ['register t ios']); // no unregister
      expect(c2.read(notificationsControllerProvider).registered, isTrue);
    },
  );

  test('session reported before start: nothing happens until ready', () async {
    await prefs.setConsent(true);
    platform.current = PushPermission.granted;
    await ctl().setSignedIn(true); // before start()
    expect(api, isEmpty);
    await ctl().start();
    expect(api, ['register t ios']);
  });
}
