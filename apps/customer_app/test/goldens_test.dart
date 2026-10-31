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
    // Milestone 5.
    (
      'profile_pixel7',
      Routes.profile,
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
    ),
    (
      'addresses_iphone15',
      Routes.addresses,
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'notification_prefs_iphone15',
      Routes.notificationPrefs,
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'reviews_pixel7',
      Routes.productReviews(2),
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
    ),
    (
      'review_editor_iphone_se',
      Routes.writeReview(1),
      const Size(320, 568),
      const EdgeInsets.only(top: 20),
    ),
    (
      'product_reviews_ipad_landscape',
      Routes.product(2),
      const Size(1194, 834),
      const EdgeInsets.only(top: 24, bottom: 20),
    ),
  ];

  for (final (name, route, size, insets) in shots) {
    testWidgets('golden: $name', (t) async {
      setDevice(t, size, insets: insets);
      final h = Harness(
        server: seededServer()
          ..seedReview(2, 5, comment: 'Fresh every morning.', helpful: 4)
          ..seedReview(2, 4, comment: 'Good, a little thin.')
          ..seedReview(2, 5, reply: 'Thank you for the kind words!')
          ..seedReview(1, 5, comment: 'Smells like home.'),
      );
      await h.start(t);
      await goTo(t, route);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
}
