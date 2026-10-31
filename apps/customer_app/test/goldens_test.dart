@Tags(['golden'])
library;

import 'package:customer_app/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/seed.dart';

/// Pixel snapshots of the core milestone-2 screens, with the real bundled
/// fonts. Regenerate after an intended UI change:
///   flutter test --update-goldens --tags golden
void main() {
  setUpAll(loadFonts);

  final shots = <(String, String, Size, EdgeInsets)>[
    (
      'cart_iphone15',
      Routes.cart,
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'product_iphone15',
      Routes.product(2),
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'checkout_pixel7',
      Routes.checkout,
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
    ),
    (
      'order_detail_pixel7',
      Routes.order(2),
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
    ),
    (
      'subscriptions_iphone15',
      Routes.subscriptions,
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'wallet_iphone_se',
      Routes.wallet,
      const Size(320, 568),
      const EdgeInsets.only(top: 20),
    ),
    (
      'shop_ipad_landscape',
      Routes.shop,
      const Size(1194, 834),
      const EdgeInsets.only(top: 24, bottom: 20),
    ),
  ];

  for (final (name, route, size, insets) in shots) {
    testWidgets('golden: $name', (t) async {
      setDevice(t, size, insets: insets);
      final h = Harness(server: seededServer());
      await h.start(t);
      await goTo(t, route);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
}
