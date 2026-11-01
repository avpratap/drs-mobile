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
    (
      'about_pixel7',
      Routes.about,
      const Size(412, 915),
      const EdgeInsets.only(top: 24, bottom: 24),
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

  // Milestone 7: sync / freshness states.
  deliveryTest('golden: today_offline_saved_route_iphone15', (t, h) async {
    setDevice(
      t,
      const Size(393, 852),
      insets: const EdgeInsets.only(top: 59, bottom: 34),
    );
    await h.start(t);
    h
      ..server.offline = true
      ..now = DateTime(2026, 11, 1, 8, 35);
    await t.fling(find.byType(Scrollable).first, const Offset(0, 400), 1000);
    await t.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/today_offline_saved_route_iphone15.png'),
    );
  });

  deliveryTest('golden: stop_conflict_pixel7', (t, h) async {
    setDevice(
      t,
      const Size(412, 915),
      insets: const EdgeInsets.only(top: 24, bottom: 24),
    );
    await h.start(t);
    h.server.offline = true;
    await goTo(t, Routes.stop(11));
    await t.tap(find.text('Mark delivered'));
    await t.pumpAndSettle();
    await t.tap(find.text('Take photo'));
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('Confirm delivery'));
    await t.tap(find.text('Confirm delivery'));
    await t.pumpAndSettle();
    h.server.orders.firstWhere((o) => o['id'] == 11)['status'] = 'failed';
    h.server.offline = false;
    await goTo(t, Routes.today);
    await t.tap(find.text('Sync now'));
    await t.pumpAndSettle();
    await goTo(t, Routes.stop(11));
    // Let the earlier "saved" snackbar expire so the shot is deterministic.
    await t.pump(const Duration(seconds: 6));
    await t.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/stop_conflict_pixel7.png'),
    );
  });

  // Brand lockup across the device matrix.
  for (final (name, size, insets) in const [
    ('iphone_se', Size(320, 568), EdgeInsets.only(top: 20)),
    ('pixel7', Size(412, 915), EdgeInsets.only(top: 24, bottom: 24)),
    ('iphone15', Size(393, 852), EdgeInsets.only(top: 59, bottom: 34)),
    ('ipad_landscape', Size(1194, 834), EdgeInsets.only(top: 24, bottom: 20)),
  ]) {
    if (name == 'iphone_se') continue; // login_iphone_se above
    deliveryTest(
      'golden: login_$name',
      harness: () => Harness(signedIn: false),
      (t, h) async {
        setDevice(t, size, insets: insets);
        await h.start(t);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/login_$name.png'),
        );
      },
    );
  }
}
