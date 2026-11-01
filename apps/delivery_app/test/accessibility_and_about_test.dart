import 'package:delivery_app/src/routes.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    ('Pixel 7, 2x text', const Size(412, 915), 2.0),
  ]) {
    deliveryTest('$name: screen-reader names, tap targets, no overflow', (
      t,
      h,
    ) async {
      final semantics = t.ensureSemantics();
      setDevice(t, size, textScale: scale);
      await h.start(t);
      for (final route in screens) {
        await goTo(t, route);
        expect(t.takeException(), isNull, reason: '$route at ${scale}x');
        expect(
          screenReaderProblems(
            t
                .binding
                .renderViews
                .first
                .owner!
                .semanticsOwner!
                .rootSemanticsNode!,
          ),
          isEmpty,
          reason: route,
        );
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

  deliveryTest(
    'sign-in (phone and code steps) at 2x text: no overflow, named controls',
    harness: () => Harness(signedIn: false),
    (t, h) async {
      final semantics = t.ensureSemantics();
      setDevice(t, const Size(360, 640), textScale: 2);
      await h.start(t);
      SemanticsNode root() =>
          t.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!;
      expect(t.takeException(), isNull);
      expect(screenReaderProblems(root()), isEmpty);
      await t.enterText(find.byType(TextField), '9999900003');
      await t.pump();
      await t.scrollUntilVisible(
        find.text('Send OTP'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await t.tap(find.text('Send OTP'));
      await t.pumpAndSettle();
      expect(find.text('Code sent to +91 99•••••003'), findsOneWidget);
      expect(t.takeException(), isNull);
      expect(screenReaderProblems(root()), isEmpty);
      semantics.dispose();
    },
  );

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
