import 'package:customer_app/src/core/push.dart';
import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/seed.dart';

PushPayload _p(Map<String, Object?> d) => PushPayload.fromData(d);

void main() {
  group('tap routing table', () {
    test('orders → detail (or list without id)', () {
      expect(
        customerPushRoute(_p({'type': 'order.confirmed', 'order_id': '9'})),
        '/account/orders/9',
      );
      expect(
        customerPushRoute(
          _p({'type': 'shipment.out_for_delivery', 'order_id': '9'}),
        ),
        '/account/orders/9',
      );
      expect(customerPushRoute(_p({'type': 'order.delivered'})), Routes.orders);
    });

    test('subscription, wallet, promo', () {
      expect(
        customerPushRoute(_p({'type': 'subscription.reminder'})),
        Routes.subscriptions,
      );
      expect(customerPushRoute(_p({'type': 'wallet.low'})), Routes.wallet);
      expect(customerPushRoute(_p({'type': 'promo'})), Routes.shop);
      expect(
        customerPushRoute(_p({'type': 'promo', 'product_id': '2'})),
        Routes.product(2),
      );
    });

    test('rider pushes and junk just open the app', () {
      expect(customerPushRoute(_p({'type': 'route.assigned'})), isNull);
      expect(customerPushRoute(_p({'type': 'evil', 'link': '/admin'})), isNull);
    });
  });

  testWidgets('opt-in on Home → OS prompt → token registered with the '
      'backend; Account shows it on', (t) async {
    setDevice(t, const Size(412, 915));
    final push = FakePushPlatform();
    final h = Harness(server: seededServer(), push: push);
    await h.start(t);

    expect(find.byType(DrsNotificationOptIn), findsOneWidget);
    expect(push.prompts, 0); // never prompted at launch
    await t.tap(find.text('Allow notifications'));
    await t.pumpAndSettle();

    expect(push.prompts, 1);
    expect(h.server.deviceTokens, {push.currentToken: 'ios'});
    final call = h.server.callsTo('POST /api/v1/account/device-tokens').single;
    expect(
      call.path,
      isNot(contains(push.currentToken!)),
    ); // token only in the body
    expect(find.byType(DrsNotificationOptIn), findsNothing);

    await goTo(t, Routes.account);
    expect(find.text('On for this device'), findsOneWidget);
  });

  testWidgets('permission denied: nothing registered, switch explains', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final push = FakePushPlatform(grant: PushPermission.denied);
    final h = Harness(server: seededServer(), push: push);
    await h.start(t);
    await t.tap(find.text('Allow notifications'));
    await t.pumpAndSettle();
    expect(h.server.deviceTokens, isEmpty);
    await goTo(t, Routes.account);
    expect(find.textContaining('Blocked in system settings'), findsOneWidget);
  });

  testWidgets('sign-out unregisters the token BEFORE revoking the session', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final push = FakePushPlatform();
    final h = Harness(server: seededServer(), push: push);
    await h.start(t);
    await t.tap(find.text('Allow notifications'));
    await t.pumpAndSettle();

    await goTo(t, Routes.account);
    await t.scrollUntilVisible(
      find.text('Sign out'),
      100,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await t.tap(find.text('Sign out'));
    await t.pumpAndSettle();
    await t.tap(find.text('Sign out').last);
    await t.pumpAndSettle();

    final order = h.server.calls.map((c) => c.key).toList();
    final unreg = order.indexOf(
      'POST /api/v1/account/device-tokens/unregister',
    );
    final logout = order.indexOf('POST /api/v1/auth/logout');
    expect(unreg, isNonNegative);
    expect(unreg, lessThan(logout == -1 ? order.length : logout));
    expect(h.server.deviceTokens, isEmpty);
    expect(await h.pushPrefs.consent(), isNull); // next user is asked again
  });

  testWidgets('tapping pushes opens the right screen (foreground/background)', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final push = FakePushPlatform();
    final h = Harness(server: seededServer(), push: push);
    await h.start(t);

    push.openedCtl.add({'type': 'order.delivered', 'order_id': '2'});
    await t.pumpAndSettle();
    expect(find.text('DRS-002'), findsWidgets);
    expect(find.text('Tracking'), findsOneWidget);

    push.openedCtl.add({'type': 'wallet.low'});
    await t.pumpAndSettle();
    expect(find.text('Wallet balance'), findsOneWidget);

    push.openedCtl.add({'type': 'subscription.reminder'});
    await t.pumpAndSettle();
    expect(find.text('Home delivery'), findsOneWidget);
  });

  testWidgets('cold start from a tapped notification lands on the order', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final push = FakePushPlatform()
      ..launchedWith = {'type': 'order.confirmed', 'order_id': '1'};
    final h = Harness(server: seededServer(), push: push);
    await h.start(t);
    expect(find.text('DRS-001'), findsWidgets);
  });

  testWidgets('a tap before sign-in waits for the session', (t) async {
    setDevice(t, const Size(412, 915));
    final push = FakePushPlatform()..launchedWith = {'type': 'wallet.low'};
    final h = Harness(server: seededServer(), push: push, signedIn: false);
    await h.start(t);
    expect(find.text('Sign in'), findsOneWidget);

    await t.enterText(find.byType(TextField), '9876543210');
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();
    h.server.loggedIn = true;
    await t.enterText(find.byType(TextField), '123456');
    await t.pumpAndSettle();
    expect(find.text('Wallet balance'), findsOneWidget);
  });

  testWidgets('golden: Home with the notification opt-in', (t) async {
    await loadFonts();
    setDevice(
      t,
      const Size(393, 852),
      insets: const EdgeInsets.only(top: 59, bottom: 34),
    );
    final h = Harness(server: seededServer(), push: FakePushPlatform());
    await h.start(t);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_push_optin_iphone15.png'),
    );
  }, tags: ['golden']);
}
