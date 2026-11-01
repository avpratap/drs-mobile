import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('iPad landscape: the rail lockup tile sits centred over the '
      'destination icons; Home shows one logo, not two', (t) async {
    setDevice(t, const Size(1194, 834), insets: const EdgeInsets.only(top: 24));
    await Harness().start(t);
    await goTo(t, Routes.home);

    final tile = find.descendant(
      of: find.byType(NavigationRail),
      matching: find.byType(DrsLogoMark),
    );
    final homeIcon = find.descendant(
      of: find.byType(NavigationRail),
      matching: find.byIcon(Icons.home),
    );
    expect(
      (t.getCenter(tile).dx - t.getCenter(homeIcon).dx).abs(),
      lessThan(1),
    );
    expect(find.byType(DrsLogo), findsOneWidget); // rail only
  });

  testWidgets('iPad: sign-in logo + form are centred as one block', (t) async {
    setDevice(t, const Size(1194, 834), insets: const EdgeInsets.only(top: 24));
    await Harness(signedIn: false).start(t);
    final logo = t.getRect(find.byType(DrsLogo));
    final button = t.getRect(
      find.ancestor(
        of: find.text('Send OTP'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      ),
    );
    final top = logo.top;
    final bottom = t.getRect(find.textContaining('By continuing')).bottom;
    // Centred in the area below the status bar, left edges aligned.
    expect(((top + bottom) / 2 - (24 + 834) / 2).abs(), lessThan(4));
    expect(
      (logo.left - t.getRect(find.text('Sign in')).left).abs(),
      lessThan(3),
    );
    expect(button.width, greaterThan(300));
  });
}
