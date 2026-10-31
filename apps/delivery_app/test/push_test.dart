import 'package:delivery_app/src/core/push.dart';
import 'package:delivery_app/src/routes.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

int _routeCalls(Harness h) =>
    h.server.callsTo('GET /api/v1/delivery/orders/route').length;

void main() {
  test('rider routing table: route pushes → Today, others just open', () {
    for (final type in [
      'route.assigned',
      'route.changed',
      'cutoff.ready',
      'delivery.cutoff_ready',
    ]) {
      expect(
        deliveryPushRoute(PushPayload.fromData({'type': type})),
        Routes.today,
        reason: type,
      );
    }
    expect(
      deliveryPushRoute(
        PushPayload.fromData({'type': 'order.delivered', 'order_id': '1'}),
      ),
      isNull,
    );
    expect(deliveryPushRoute(PushPayload.fromData({'type': 'x'})), isNull);
  });

  deliveryTest(
    'opt-in on Today registers the token; bell sheet shows it on',
    harness: () => Harness(push: FakePushPlatform()),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      expect(find.text('Get route alerts'), findsOneWidget);
      await t.tap(find.text('Allow notifications'));
      await t.pumpAndSettle();
      expect(h.server.deviceTokens, {h.push!.currentToken: 'ios'});
      expect(find.text('Get route alerts'), findsNothing);

      await t.tap(find.byTooltip('Notifications'));
      await t.pumpAndSettle();
      expect(find.text('On for this device'), findsOneWidget);
    },
  );

  deliveryTest(
    'tapping a route push opens Today and refetches the route',
    harness: () => Harness(push: FakePushPlatform()),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      await goTo(t, Routes.stop(11));
      final before = _routeCalls(h);

      h.push!.openedCtl.add({'type': 'route.changed'});
      await t.pumpAndSettle();
      expect(find.text("Today's deliveries"), findsOneWidget);
      expect(_routeCalls(h), greaterThan(before));
    },
  );

  deliveryTest(
    'a route push received in the foreground refreshes the list',
    harness: () => Harness(push: FakePushPlatform()),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      final before = _routeCalls(h);
      h.server.orders.first['status'] = 'delivered'; // changed server-side
      h.push!.fgCtl.add(
        const PushMessage(
          title: 'Route updated',
          data: {'type': 'route.changed'},
        ),
      );
      await t.pumpAndSettle();
      expect(_routeCalls(h), greaterThan(before));
      expect(find.text('2 of 3 delivered'), findsOneWidget);
    },
  );

  deliveryTest(
    'log out unregisters the token before revoking the session',
    harness: () => Harness(push: FakePushPlatform()),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      await t.tap(find.text('Allow notifications'));
      await t.pumpAndSettle();
      await t.tap(find.byTooltip('More'));
      await t.pumpAndSettle();
      await t.tap(find.text('Log out'));
      await t.pumpAndSettle();
      await t.tap(find.text('Log out').last);
      await t.pumpAndSettle();

      final keys = h.server.calls.map((c) => c.key).toList();
      final unreg = keys.indexOf(
        'POST /api/v1/account/device-tokens/unregister',
      );
      final logout = keys.indexOf('POST /api/v1/auth/logout');
      expect(unreg, isNonNegative);
      expect(unreg, lessThan(logout));
      expect(h.server.deviceTokens, isEmpty);
      expect(await h.pushPrefs.consent(), isNull);
    },
  );

  deliveryTest(
    'permission denied is explained, nothing registered',
    harness: () =>
        Harness(push: FakePushPlatform(grant: PushPermission.denied)),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      await t.tap(find.text('Allow notifications'));
      await t.pumpAndSettle();
      expect(h.server.deviceTokens, isEmpty);
      await t.tap(find.byTooltip('Notifications'));
      await t.pumpAndSettle();
      expect(find.textContaining('Blocked in system settings'), findsOneWidget);
    },
  );

  deliveryTest(
    'golden: Today with the route-alert opt-in',
    harness: () => Harness(push: FakePushPlatform()),
    (t, h) async {
      await loadFonts();
      setDevice(
        t,
        const Size(393, 852),
        insets: const EdgeInsets.only(top: 59, bottom: 34),
      );
      await h.start(t);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/today_push_optin_iphone15.png'),
      );
    },
  );
}
