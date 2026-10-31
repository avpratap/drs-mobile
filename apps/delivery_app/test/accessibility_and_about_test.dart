import 'package:delivery_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

/// Rider screens against Flutter's tap-target and labelling guidelines
/// (contrast is checked on the theme's colour pairs in drs_ui).
final screens = <String>[
  Routes.today,
  Routes.stop(11),
  Routes.deliver(11),
  Routes.map,
  Routes.about,
  Routes.privacyNotice,
];

void main() {
  for (final (name, size, scale) in [
    ('Pixel 7', const Size(412, 915), 1.0),
    ('iPhone SE, 1.3x text', const Size(320, 568), 1.3),
  ]) {
    deliveryTest('$name: rider screens meet tap-target and label guidelines', (
      t,
      h,
    ) async {
      final semantics = t.ensureSemantics();
      setDevice(t, size, textScale: scale);
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

  deliveryTest('Today → More → About & privacy', (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    await goTo(t, Routes.today);
    await t.tap(find.byTooltip('More'));
    await t.pumpAndSettle();
    await t.tap(find.text('About & privacy'));
    await t.pumpAndSettle();
    expect(find.text('DRS Delivery'), findsOneWidget);
    expect(find.text('Version 1.0.0 (12)'), findsOneWidget);
    await t.tap(find.text('Privacy notice'));
    await t.pumpAndSettle();
    expect(find.text('What we collect'), findsOneWidget);
    expect(
      find.textContaining('does not collect your location'),
      findsOneWidget,
    );
  });
}
