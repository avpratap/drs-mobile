import 'package:customer_app/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_drs_server.dart';
import 'support/harness.dart';

/// The customer app on the catalogue exactly as the live backend serves it.
void main() {
  FakeDrsServer live() => FakeDrsServer()..liveCatalogue = LiveCatalogue.load();

  testWidgets('shop shows readable category names from backend slugs', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: live());
    await h.start(t);
    await goTo(t, Routes.shop);
    for (final label in ['All', 'Buttermilk', 'Ghee', 'Milk', 'Paneer']) {
      expect(find.widgetWithText(ChoiceChip, label), findsOneWidget);
    }
    expect(find.widgetWithText(ChoiceChip, 'buttermilk'), findsNothing);
    expect(find.text('Fresh Cow Milk 500ml'), findsOneWidget);

    await t.tap(find.widgetWithText(ChoiceChip, 'Ghee'));
    await t.pumpAndSettle();
    expect(find.text('Bilona A2 Ghee 500ml'), findsOneWidget);
    expect(find.text('Fresh Cow Milk 500ml'), findsNothing);
  });

  testWidgets('a product without pack-size variants can still be bought', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: live());
    await h.start(t);
    await goTo(t, Routes.product(3));
    expect(find.text('Buttermilk (Chaas) 200ml'), findsWidgets);
    expect(find.text('Buttermilk'), findsOneWidget); // category label
    final add = find.textContaining('Add ·');
    await t.ensureVisible(add);
    await t.tap(add);
    await t.pumpAndSettle();
    final call = h.server.callsTo('POST /api/v1/cart/items').single;
    expect((call.body! as Map)['product_id'], 3);
    expect(t.takeException(), isNull);
  });

  testWidgets('a product with variants lists its pack sizes', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: live());
    await h.start(t);
    await goTo(t, Routes.product(1));
    expect(find.text('500ml'), findsOneWidget);
    expect(find.text('1L'), findsOneWidget);
  });
}
