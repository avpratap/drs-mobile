import 'package:customer_app/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/seed.dart';

/// Same device matrix as responsive_test.dart, over the milestone-2 screens.
const devices = <(String, Size, EdgeInsets, double)>[
  ('iPhone SE 320', Size(320, 568), EdgeInsets.only(top: 20), 1),
  ('small Android 1.5x text', Size(360, 640), EdgeInsets.only(top: 24), 1.5),
  ('iPhone 15', Size(393, 852), EdgeInsets.only(top: 59, bottom: 34), 1),
  ('Pixel 7', Size(412, 915), EdgeInsets.only(top: 24, bottom: 24), 1),
  (
    'iPhone 15 landscape',
    Size(852, 393),
    EdgeInsets.only(left: 59, right: 59, bottom: 21),
    1,
  ),
  ('iPad landscape', Size(1194, 834), EdgeInsets.only(top: 24, bottom: 20), 1),
];

/// Route → a text that proves the screen rendered its data.
final screens = <(String, String)>[
  (Routes.product(2), 'Pack size'),
  (Routes.cart, 'Cow Milk'),
  (Routes.checkout, 'Deliver to'),
  (Routes.orders, 'DRS-002'),
  (Routes.order(2), 'Tracking'),
  (Routes.wallet, 'Wallet balance'),
  (Routes.addresses, 'Home'),
  (Routes.subscriptions, 'Home delivery'),
  (Routes.subscribeProduct(2), 'How often'),
];

void main() {
  for (final (name, size, insets, scale) in devices) {
    testWidgets(
      '$name: commerce screens fit, clear the notch and home indicator',
      variant: const TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
      (t) async {
        setDevice(t, size, insets: insets, textScale: scale);
        final h = Harness(server: seededServer());
        await h.start(t);

        for (final (route, marker) in screens) {
          await goTo(t, route);
          expect(t.takeException(), isNull, reason: route);
          expect(find.textContaining(marker), findsWidgets, reason: route);

          // App bars paint behind the status bar, but their toolbar (title,
          // actions) must sit below the status bar / notch / Dynamic Island.
          final toolbar = find.byType(NavigationToolbar);
          if (toolbar.evaluate().isNotEmpty) {
            expect(
              t.getTopLeft(toolbar.last).dy,
              greaterThanOrEqualTo(insets.top),
              reason: route,
            );
          }
        }

        // Sticky bottom actions clear the home indicator.
        for (final (route, label) in [
          (Routes.cart, 'Checkout · '),
          (Routes.checkout, 'Place order & pay · '),
        ]) {
          await goTo(t, route);
          final button = find.textContaining(label);
          expect(button, findsOneWidget, reason: route);
          expect(
            t.getBottomLeft(button).dy,
            lessThanOrEqualTo(size.height - insets.bottom),
            reason: route,
          );
        }
      },
    );
  }
}
