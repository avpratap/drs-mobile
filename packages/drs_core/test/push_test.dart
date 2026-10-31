import 'package:drs_core/drs_core.dart';
import 'package:test/test.dart';

void main() {
  group('PushPayload (untrusted data)', () {
    test('known types and backend aliases', () {
      expect(PushKind.parse('order.confirmed'), PushKind.orderConfirmed);
      expect(PushKind.parse('payment.success'), PushKind.orderConfirmed);
      expect(PushKind.parse('shipment.delivered'), PushKind.orderDelivered);
      expect(PushKind.parse('subscription.reminder'), PushKind.subscription);
      expect(PushKind.parse('subscription.paused'), PushKind.subscription);
      expect(PushKind.parse('wallet.low'), PushKind.walletLow);
      expect(PushKind.parse('marketing.promo'), PushKind.promo);
      expect(PushKind.parse('route.changed'), PushKind.routeChanged);
      expect(PushKind.parse('delivery.cutoff_ready'), PushKind.cutoffReady);
      expect(PushKind.parse('javascript:alert(1)'), PushKind.unknown);
      expect(PushKind.parse(null), PushKind.unknown);
    });

    test('ids must be positive integers; anything else is dropped', () {
      expect(
        PushPayload.fromData({'type': 'order.delivered', 'order_id': '42'}),
        const PushPayload(kind: PushKind.orderDelivered, orderId: 42),
      );
      final bad = PushPayload.fromData({
        'type': 'order.delivered',
        'order_id': '../../admin',
        'subscription_id': '-3',
        'link': 'https://evil.example',
      });
      expect(bad.orderId, isNull);
      expect(bad.subscriptionId, isNull);
    });
  });

  group('DeviceTokenRegistrar', () {
    late List<String> calls;
    late InMemoryPushPrefs prefs;
    late DeviceTokenRegistrar r;
    final t1 = 'a' * 160, t2 = 'b' * 160;

    setUp(() {
      calls = [];
      prefs = InMemoryPushPrefs();
      r = DeviceTokenRegistrar(
        register: (t, p) async => calls.add('register ${t[0]} $p'),
        unregister: (t) async => calls.add('unregister ${t[0]}'),
        prefs: prefs,
        platform: 'android',
      );
    });

    test('nothing is registered without consent', () async {
      expect(
        await r.sync(signedIn: true, token: t1),
        TokenSyncResult.unchanged,
      );
      await prefs.setConsent(false);
      expect(
        await r.sync(signedIn: true, token: t1),
        TokenSyncResult.unchanged,
      );
      expect(calls, isEmpty);
    });

    test(
      'registers once with consent, idempotent, rotates on refresh',
      () async {
        await prefs.setConsent(true);
        expect(
          await r.sync(signedIn: true, token: t1),
          TokenSyncResult.registered,
        );
        expect(
          await r.sync(signedIn: true, token: t1),
          TokenSyncResult.unchanged,
        );
        expect(
          await r.sync(signedIn: true, token: t2),
          TokenSyncResult.registered,
        );
        expect(calls, [
          'register a android',
          'unregister a',
          'register b android',
        ]);
        expect(await prefs.registeredToken(), t2);
      },
    );

    test('opt-out deactivates the token', () async {
      await prefs.setConsent(true);
      await r.sync(signedIn: true, token: t1);
      await prefs.setConsent(false);
      expect(
        await r.sync(signedIn: true, token: t1),
        TokenSyncResult.unregistered,
      );
      expect(calls.last, 'unregister a');
      expect(await prefs.registeredToken(), isNull);
    });

    test('sign-out unregisters and clears consent for the next user', () async {
      await prefs.setConsent(true);
      await r.sync(signedIn: true, token: t1);
      await r.signOut();
      expect(calls.last, 'unregister a');
      expect(await prefs.registeredToken(), isNull);
      expect(await prefs.consent(), isNull);
      // Signed out: no API calls.
      expect(
        await r.sync(signedIn: false, token: t1),
        TokenSyncResult.unchanged,
      );
    });

    test('a failed registration is retried on the next sync', () async {
      var fail = true;
      final flaky = DeviceTokenRegistrar(
        register: (t, p) async {
          if (fail) throw StateError('offline');
          calls.add('register');
        },
        unregister: (_) async {},
        prefs: prefs,
        platform: 'ios',
      );
      await prefs.setConsent(true);
      expect(
        await flaky.sync(signedIn: true, token: t1),
        TokenSyncResult.failed,
      );
      expect(await prefs.registeredToken(), isNull);
      fail = false;
      expect(
        await flaky.sync(signedIn: true, token: t1),
        TokenSyncResult.registered,
      );
    });
  });

  test('Firebase is configured only when every value is defined', () {
    const none = DrsEnv(flavor: DrsFlavor.dev, apiBaseUrl: 'http://x');
    expect(none.hasFirebase(ios: false), isFalse);
    const android = DrsEnv(
      flavor: DrsFlavor.dev,
      apiBaseUrl: 'http://x',
      fcmSenderId: '1',
      firebaseApiKey: 'k',
      firebaseProjectId: 'p',
      firebaseAppIdAndroid: '1:1:android:a',
    );
    expect(android.hasFirebase(ios: false), isTrue);
    expect(android.hasFirebase(ios: true), isFalse);
    expect(android.toString(), isNot(contains('k,')));
  });
}
