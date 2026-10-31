import 'package:customer_app/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Map<String, Object?> _order(
  int id, {
  String status = 'created',
  String pay = 'pending',
}) => {
  'id': id,
  'order_no': 'DRS-00$id',
  'shop_id': 1,
  'order_type': 'd2c',
  'status': status,
  'payment_status': pay,
  'subtotal': 64,
  'discount': 0,
  'total': 64,
  'tax_total': 0,
  'items': [
    {'product_id': 2, 'qty': 1, 'unit_price': 64, 'line_total': 64},
  ],
};

void main() {
  testWidgets('wallet shows balance and signed ledger lines', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    await h.start(t);
    await goTo(t, Routes.account);
    await t.tap(find.text('Wallet & billing'));
    await t.pumpAndSettle();
    expect(find.text('₹250.00'), findsOneWidget);
    expect(find.text('Order debit'), findsOneWidget);
    expect(find.text('−₹64.00'), findsOneWidget);
    expect(find.text('+₹314.00'), findsOneWidget);
  });

  testWidgets('order history → detail; unpaid order can be cancelled', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    h.server.orders.addAll([
      _order(2),
      _order(1, status: 'delivered', pay: 'paid'),
    ]);
    await h.start(t);
    await goTo(t, Routes.orders);

    expect(find.text('DRS-002'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
    await t.tap(find.text('DRS-002'));
    await t.pumpAndSettle();
    expect(find.text('Pay now · ₹64.00'), findsOneWidget);
    await t.tap(find.text('Cancel order'));
    await t.pumpAndSettle();
    await t.tap(find.text('Cancel order').last);
    await t.pumpAndSettle();
    expect(h.server.callsTo('POST /api/v1/orders/2/cancel'), hasLength(1));
    expect(find.text('Cancelled'), findsWidgets);
    expect(find.text('This order was cancelled.'), findsOneWidget);
  });

  testWidgets('order history works offline; cache is wiped on sign-out', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    h.server.orders.add(_order(1));
    await h.start(t);
    await goTo(t, Routes.orders);
    expect(await h.db.readJson('orders'), isNotNull);

    h.server.offline = true;
    await goTo(t, Routes.account);
    await goTo(t, Routes.orders);
    expect(find.text('Offline — showing saved orders.'), findsOneWidget);
    expect(find.text('DRS-001'), findsOneWidget);

    h.server.offline = false;
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
    expect(await h.db.readJson('orders'), isNull);
  });
}
