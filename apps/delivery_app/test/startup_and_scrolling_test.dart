import 'package:delivery_app/src/routes.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_delivery_server.dart';
import 'support/harness.dart';

void main() {
  deliveryTest('cold start with no connection: a saved rider session opens '
      "today's saved route (not the login screen)", (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t); // online: caches today's route
    await t.pumpWidget(const SizedBox());

    h.server.offline = true;
    await t.pumpWidget(h.app());
    await t.pumpAndSettle();
    expect(find.text('Rider login'), findsNothing);
    expect(find.text("Today's deliveries"), findsOneWidget);
    expect(find.text('Shyam Dairy, Malviya Nagar'), findsOneWidget);
    expect(
      find.textContaining('Offline — showing the route saved at'),
      findsOneWidget,
    );
  });

  deliveryTest(
    'a session that turns out not to be a rider is signed out at start',
    harness: () => Harness(server: FakeDeliveryServer(role: 'customer')),
    (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      expect(find.text('Rider login'), findsOneWidget);
      expect(await h.tokens.read(), isNull);
    },
  );

  deliveryTest('a long route builds lazily and scrolls to the last shop', (
    t,
    h,
  ) async {
    setDevice(t, const Size(412, 915));
    for (var i = 0; i < 60; i++) {
      h.server.orders.add(
        FakeDeliveryServer.order(
          100 + i,
          10 + i,
          'Shop $i, Jaipur',
          'generated',
          [(2, 1)],
        ),
      );
    }
    await h.start(t);
    // 62 shops on the route, only a screenful built.
    final built = find
        .byType(DrsSection, skipOffstage: false)
        .evaluate()
        .length;
    expect(built, lessThan(15));
    await t.scrollUntilVisible(
      find.text('Shop 59, Jaipur'),
      600,
      scrollable: find.byType(Scrollable).first,
    );
    expect(t.takeException(), isNull);
    await goTo(t, Routes.today);
  });
}
