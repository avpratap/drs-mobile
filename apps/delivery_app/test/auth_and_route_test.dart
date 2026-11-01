import 'package:delivery_app/src/features/route/route_providers.dart';
import 'package:delivery_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_delivery_server.dart';
import 'support/harness.dart';

Future<void> _login(WidgetTester t) async {
  expect(find.text('Rider login'), findsOneWidget);
  await t.enterText(find.byType(TextField), '9999900003');
  await t.pump();
  await t.tap(find.text('Send OTP'));
  await t.pumpAndSettle();
  expect(find.text('Code sent to +91 99•••••003'), findsOneWidget);
  await t.tap(find.text('Use dev code 246810'));
  await t.pump();
  await t.tap(find.text('Log in'));
  await t.pumpAndSettle();
}

void main() {
  test('todayIst rolls over at IST midnight, not UTC', () {
    expect(todayIst(DateTime.utc(2026, 10, 31, 19)), DateTime.utc(2026, 11, 1));
    expect(
      todayIst(DateTime.utc(2026, 10, 31, 18)),
      DateTime.utc(2026, 10, 31),
    );
  });

  deliveryTest(
    'seeded agent logs in (shared OTP widget) and sees today grouped by shop',
    harness: () => Harness(signedIn: false),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      await _login(t);

      // Route requested for the IST day, not the backend default (tomorrow).
      final call = h.server.callsTo('GET /api/v1/delivery/orders/route').last;
      expect(call.query['date'].toString(), startsWith('2026-11-01'));

      expect(find.text("Today's deliveries"), findsOneWidget);
      expect(find.text('1 of 3 delivered'), findsOneWidget);
      expect(find.text('Shyam Dairy, Malviya Nagar'), findsOneWidget);
      expect(find.text('Gopal Kirana, Vaishali Nagar'), findsOneWidget);
      expect(find.text('0/2 done'), findsOneWidget);
      expect(find.text('1/1 done'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Out for delivery'), findsOneWidget);
      expect(find.text('Delivered'), findsOneWidget);
    },
  );

  deliveryTest(
    'non-delivery accounts are turned away and signed out',
    harness: () =>
        Harness(signedIn: false, server: FakeDeliveryServer(role: 'customer')),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      await _login(t);
      expect(find.text('Rider login'), findsOneWidget);
      expect(find.textContaining('delivery partners'), findsOneWidget);
      expect(await h.tokens.read(), isNull);
    },
  );

  deliveryTest('stop detail: names, masked phone, navigate + call hand-offs', (
    t,
    h,
  ) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    await goTo(t, Routes.stop(11));

    expect(find.text('Asha Devi'), findsOneWidget);
    expect(find.text('+91 98•••••210'), findsOneWidget);
    expect(find.text('Cow Milk'), findsOneWidget);
    expect(find.text('400 ml'), findsOneWidget);
    expect(find.text('₹94.00'), findsOneWidget);

    await t.tap(find.text('Navigate'));
    await t.tap(find.text('Call'));
    expect(h.opened.first.host, 'www.google.com');
    expect(h.opened.first.queryParameters['destination'], '26.853,75.8047');
    expect(h.opened.last.toString(), 'tel:+919876543210');
  });

  deliveryTest(
    'iOS navigates with Apple Maps',
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    (t, h) async {
      setDevice(t, const Size(393, 852));
      await h.start(t);
      await goTo(t, Routes.stop(12));
      await t.tap(find.text('Navigate'));
      expect(h.opened.single.host, 'maps.apple.com');
      expect(h.opened.single.queryParameters['daddr'], '26.861,75.812');
    },
  );

  deliveryTest('route is viewable offline from the Drift cache', (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    expect(find.text('1 of 3 delivered'), findsOneWidget);
    expect(find.text('Updated 8:00 am'), findsOneWidget);

    h.server.offline = true;
    h.now = DateTime(2026, 11, 1, 8, 35);
    await t.fling(find.byType(Scrollable).first, const Offset(0, 400), 1000);
    await t.pumpAndSettle();
    // Says how old the saved route is.
    expect(
      find.text('Offline — showing the route saved at 8:00 am (35 min ago).'),
      findsOneWidget,
    );
    expect(find.text('Shyam Dairy, Malviya Nagar'), findsOneWidget);
  });

  deliveryTest('map without a key: route sketch + hand-off with waypoints', (
    t,
    h,
  ) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    await t.tap(find.byTooltip('Map'));
    await t.pumpAndSettle();

    expect(find.bySemanticsLabel('Route sketch with 3 stops'), findsOneWidget);
    expect(find.textContaining('DRS_GOOGLE_MAPS_API_KEY'), findsOneWidget);
    await t.tap(find.text('Open route in Google Maps'));
    final uri = h.opened.single;
    // Open stops only (13 is delivered): 11 then 12.
    expect(uri.queryParameters['waypoints'], '26.853,75.8047');
    expect(uri.queryParameters['destination'], '26.861,75.812');
  });
}
