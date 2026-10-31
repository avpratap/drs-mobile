@Tags(['golden'])
library;

import 'package:delivery_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

/// Regenerate after an intended UI change:
///   flutter test --update-goldens --tags golden
void main() {
  setUpAll(loadFonts);

  final shots = <(String, String, Size, EdgeInsets)>[
    (
      'today_iphone15',
      Routes.today,
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'stop_pixel7',
      Routes.stop(11),
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
    ),
    (
      'pod_iphone15',
      Routes.deliver(11),
      const Size(393, 852),
      const EdgeInsets.only(top: 59, bottom: 34),
    ),
    (
      'map_fallback_pixel7',
      Routes.map,
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
    ),
    (
      'today_ipad_landscape',
      Routes.today,
      const Size(1194, 834),
      const EdgeInsets.only(top: 24, bottom: 20),
    ),
  ];

  for (final (name, route, size, insets) in shots) {
    deliveryTest('golden: $name', (t, h) async {
      setDevice(t, size, insets: insets);
      await h.start(t);
      await goTo(t, route);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }

  deliveryTest(
    'golden: login_iphone_se',
    harness: () => Harness(signedIn: false),
    (t, h) async {
      setDevice(
        t,
        const Size(320, 568),
        insets: const EdgeInsets.only(top: 20),
      );
      await h.start(t);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/login_iphone_se.png'),
      );
    },
  );
}
