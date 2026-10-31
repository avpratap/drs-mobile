import 'package:delivery_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

/// Same device matrix as customer_app.
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

final screens = <(String, String)>[
  (Routes.today, '1 of 3 delivered'),
  (Routes.stop(11), 'Deliver to'),
  (Routes.deliver(11), 'Delivered items'),
  (Routes.map, 'Open route in Google Maps'),
  (Routes.about, 'Version 1.0.0 (12)'),
  (Routes.privacyNotice, 'What we collect'),
];

void main() {
  for (final (name, size, insets, scale) in devices) {
    deliveryTest(
      '$name: rider screens fit and respect safe areas',
      variant: const TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
      harness: () => Harness(signedIn: false),
      (t, h) async {
        setDevice(t, size, insets: insets, textScale: scale);
        await h.start(t);
        expect(find.text('Rider login'), findsOneWidget);
        expect(t.takeException(), isNull, reason: 'login');

        await h.tokens.write(const SessionTokensForTest());
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(h.app());
        await t.pumpAndSettle();

        for (final (route, marker) in screens) {
          await goTo(t, route);
          expect(t.takeException(), isNull, reason: route);
          expect(find.textContaining(marker), findsWidgets, reason: route);
          final toolbar = find.byType(NavigationToolbar);
          if (toolbar.evaluate().isNotEmpty) {
            expect(
              t.getTopLeft(toolbar.last).dy,
              greaterThanOrEqualTo(insets.top),
              reason: route,
            );
          }
        }

        // Wide screens show the list and the map side by side (judged on the
        // width left after notch insets).
        await goTo(t, Routes.today);
        expect(
          find.bySemanticsLabel('Route sketch with 3 stops'),
          size.width - insets.horizontal >= 840 ? findsOneWidget : findsNothing,
        );

        // Sticky action buttons clear the home indicator.
        for (final (route, label) in [
          (Routes.stop(11), 'Mark delivered'),
          (Routes.deliver(11), 'Confirm delivery'),
        ]) {
          await goTo(t, route);
          expect(
            t.getBottomLeft(find.text(label)).dy,
            lessThanOrEqualTo(size.height - insets.bottom),
            reason: route,
          );
        }
      },
    );
  }
}
