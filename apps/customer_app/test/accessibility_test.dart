import 'package:customer_app/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/seed.dart';

/// Every main screen against Flutter's accessibility guidelines: 48dp (Android)
/// / 44pt (iOS) tap targets and labelled tap targets. Colour contrast is
/// checked on the theme's colour pairs in drs_ui (contrast_test.dart): the
/// screenshot-based textContrastGuideline misreads anti-aliased small text.
final screens = <String>[
  Routes.home,
  Routes.shop,
  Routes.product(2),
  Routes.productReviews(2),
  Routes.writeReview(2),
  Routes.cart,
  Routes.checkout,
  Routes.subscriptions,
  Routes.subscribeProduct(2),
  Routes.account,
  Routes.orders,
  Routes.order(2),
  Routes.wallet,
  Routes.addresses,
  Routes.newAddress,
  Routes.profile,
  Routes.notificationPrefs,
  Routes.about,
  Routes.privacyNotice,
];

void main() {
  setUpAll(loadFonts);

  for (final (name, size, scale) in [
    ('Pixel 7', const Size(412, 915), 1.0),
    ('iPhone SE, 1.3x text', const Size(320, 568), 1.3),
  ]) {
    testWidgets('$name: screens meet tap-target, and label guidelines', (
      t,
    ) async {
      final semantics = t.ensureSemantics();
      setDevice(t, size, textScale: scale);
      final h = Harness(
        server: seededServer()
          ..seedReview(2, 5, comment: 'Fresh every morning.', helpful: 2),
      );
      await h.start(t);
      for (final route in screens) {
        await goTo(t, route);
        await expectLater(
          t,
          meetsGuideline(androidTapTargetGuideline),
          reason: route,
        );
        await expectLater(
          t,
          meetsGuideline(iOSTapTargetGuideline),
          reason: route,
        );
        await expectLater(
          t,
          meetsGuideline(labeledTapTargetGuideline),
          reason: route,
        );
      }
      semantics.dispose();
    });
  }
}
