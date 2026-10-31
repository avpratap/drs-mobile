import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/seed.dart';

/// Every main screen for TalkBack/VoiceOver and large text: every control
/// has a spoken name that isn't just a number, 48dp (Android) / 44pt (iOS)
/// tap targets, labelled tap targets, and no layout overflow up to 2x text. Colour contrast is
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
    // Android 14's largest font size; iOS accessibility sizes go further but
    // Flutter apps commonly clamp; 2x must never overflow.
    ('Pixel 7, 2x text', const Size(412, 915), 2.0),
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
        // Layout overflow at large text is reported as an exception.
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

  testWidgets('sign-in (phone and code steps) at 2x text: no overflow, '
      'named controls', (t) async {
    final semantics = t.ensureSemantics();
    setDevice(t, const Size(360, 640), textScale: 2);
    await Harness(signedIn: false).start(t);
    SemanticsNode root() =>
        t.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!;
    expect(t.takeException(), isNull);
    expect(screenReaderProblems(root()), isEmpty);
    await t.enterText(find.byType(TextField), '9876543210');
    await t.pump();
    await t.scrollUntilVisible(
      find.text('Send OTP'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();
    expect(find.text('Code sent to +91 98•••••210'), findsOneWidget);
    expect(t.takeException(), isNull);
    expect(screenReaderProblems(root()), isEmpty);
    semantics.dispose();
  });

  testWidgets('address form: keyboard Next walks the fields top to bottom; '
      'Done on the last field saves', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    await h.start(t);
    await goTo(t, Routes.newAddress);

    String? focusedLabel() {
      final f = FocusManager.instance.primaryFocus?.context;
      return f
          ?.findAncestorWidgetOfExactType<TextField>()
          ?.decoration
          ?.labelText;
    }

    await t.tap(find.widgetWithText(TextFormField, 'House / flat, street'));
    await t.pump();
    final order = <String?>[focusedLabel()];
    for (var i = 0; i < 4; i++) {
      await t.testTextInput.receiveAction(TextInputAction.next);
      await t.pump();
      order.add(focusedLabel());
    }
    expect(order, [
      'House / flat, street',
      'Area / locality (optional)',
      'Landmark (optional)',
      'City',
      // The State dropdown is next in visual order.
      null,
    ]);

    await t.tap(find.widgetWithText(TextFormField, 'Save as'));
    await t.pump();
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pumpAndSettle();
    // Validation ran (required fields empty) — i.e. Done submitted the form.
    expect(find.text('Required'), findsWidgets);
    expect(h.server.callsTo('POST /api/v1/addresses'), isEmpty);
  });
}
