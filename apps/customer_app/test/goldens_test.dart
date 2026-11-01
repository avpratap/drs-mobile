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
    // Milestone 6.
    (
      'about_iphone15',
      Routes.about,
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'privacy_notice_pixel7',
      Routes.privacyNotice,
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
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

  // Milestone 7: connection and failure states.
  testWidgets('golden: home_offline_strip_iphone15', (t) async {
    setDevice(
      t,
      const Size(393, 852),
      insets: const EdgeInsets.only(top: 59, bottom: 34),
    );
    final h = Harness(server: seededServer());
    await h.start(t);
    h.server.offline = true;
    await goTo(t, Routes.orders); // a request fails -> app knows it's offline
    await goTo(t, Routes.home);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_offline_strip_iphone15.png'),
    );
  });

  testWidgets('golden: wallet_offline_pixel7', (t) async {
    setDevice(
      t,
      const Size(412, 915),
      insets: const EdgeInsets.only(top: 24, bottom: 24),
    );
    final h = Harness(server: seededServer());
    await h.start(t);
    h.server.offline = true;
    await goTo(t, Routes.wallet);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wallet_offline_pixel7.png'),
    );
  });

  testWidgets('golden: wallet_server_error_pixel7', (t) async {
    setDevice(
      t,
      const Size(412, 915),
      insets: const EdgeInsets.only(top: 24, bottom: 24),
    );
    final h = Harness(server: seededServer());
    await h.start(t);
    h.server.failAllWith = 503;
    await goTo(t, Routes.wallet);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wallet_server_error_pixel7.png'),
    );
  });

  // Brand lockup across the device matrix (sign-in shows it largest).
  for (final (name, size, insets) in const [
    ('iphone_se', Size(320, 568), EdgeInsets.only(top: 20)),
    ('pixel7', Size(412, 915), EdgeInsets.only(top: 24, bottom: 24)),
    ('iphone15', Size(393, 852), EdgeInsets.only(top: 59, bottom: 34)),
    ('ipad_landscape', Size(1194, 834), EdgeInsets.only(top: 24, bottom: 20)),
  ]) {
    testWidgets('golden: sign_in_$name', (t) async {
      setDevice(t, size, insets: insets);
      await Harness(signedIn: false).start(t);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/sign_in_$name.png'),
      );
    });
  }
}
