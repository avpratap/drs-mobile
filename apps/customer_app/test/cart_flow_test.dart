import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('quick-add a pack from Shop, badge updates, cart shows server '
      'GST-inclusive totals, stepper and removal go to the server', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    await h.start(t);
    await goTo(t, Routes.shop);

    // Quick add on Cow Milk opens the pack sheet with storefront prices.
    final milkCard = find.ancestor(
      of: find.text('Cow Milk'),
      matching: find.byType(DrsProductCard),
    );
    await t.tap(find.descendant(of: milkCard, matching: find.text('Add')));
    await t.pumpAndSettle();
    expect(find.text('500 ml'), findsWidgets);
    expect(find.text('1 L'), findsOneWidget);

    await t.tap(find.text('1 L'));
    await t.pump();
    await t.tap(find.byTooltip('Increase').last); // 2 packs
    await t.pump();
    expect(find.text('Add · ₹128'), findsOneWidget);
    await t.tap(find.text('Add · ₹128'));
    await t.pumpAndSettle();

    // One cart line of 2 L (qty is in the product uom).
    final add = h.server.callsTo('POST /api/v1/cart/items').single;
    expect(add.body, {'product_id': 2, 'qty': 2});
    expect(find.byTooltip('Cart, 1 items'), findsOneWidget);

    // Cart screen: server line total + quote's GST.
    await t.tap(find.byTooltip('Cart, 1 items'));
    await t.pumpAndSettle();
    expect(find.text('2 L · ₹64.00 / litre'), findsOneWidget);
    expect(find.text('₹128.00'), findsWidgets);
    expect(find.text('Includes GST'), findsOneWidget);
    expect(find.text('Checkout · ₹128.00'), findsOneWidget);

    // Stepper counts base packs (500 ml): 4 → 5 = 2.5 L.
    await t.tap(find.byTooltip('Increase'));
    await t.pumpAndSettle();
    expect(h.server.callsTo('PATCH /api/v1/cart/items/100').single.body, {
      'qty': 2.5,
    });
    expect(find.text('Checkout · ₹160.00'), findsOneWidget);

    // Swipe to remove.
    await t.drag(
      find.byKey(const ValueKey('cart-line-100')),
      const Offset(-500, 0),
    );
    await t.pumpAndSettle();
    expect(h.server.callsTo('DELETE /api/v1/cart/items/100'), hasLength(1));
    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('product page: pack chips, MRP strike-through, add to cart', (
    t,
  ) async {
    setDevice(
      t,
      const Size(393, 852),
      insets: const EdgeInsets.only(top: 59, bottom: 34),
    );
    final h = Harness();
    await h.start(t);
    await goTo(t, Routes.product(2));

    expect(find.text('Cow Milk'), findsWidgets);
    expect(find.text('Subscribe for regular delivery'), findsOneWidget);
    await t.tap(find.text('1 L'));
    await t.pump();
    // ₹64 selling price with ₹70 MRP struck through.
    expect(
      find.bySemanticsLabel(RegExp(r'₹64 per 1 L was ₹70')),
      findsOneWidget,
    );
    await t.tap(find.text('Add · ₹64'));
    await t.pumpAndSettle();
    expect(h.server.cart, {2: 1.0});
    expect(find.text('Added to cart'), findsOneWidget);
  });
}
