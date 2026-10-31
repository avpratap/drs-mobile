import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('Account → About shows version and build; licences include '
      'the bundled fonts', (t) async {
    registerDrsLicenses();
    setDevice(t, const Size(412, 915));
    final h = Harness();
    await h.start(t);
    await goTo(t, Routes.account);
    await t.scrollUntilVisible(
      find.text('About'),
      100,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await t.tap(find.text('About'));
    await t.pumpAndSettle();

    expect(find.text('DRS Dairy'), findsOneWidget);
    expect(find.text('Version 1.0.0 (12)'), findsOneWidget);
    // The harness points at an explicit base URL, so its host is shown.
    expect(find.text('Build: dev · test'), findsOneWidget);

    await t.tap(find.text('Open-source licences'));
    await t.pumpAndSettle();
    expect(find.text('Poppins font'), findsOneWidget);
    expect(find.text('Montserrat font'), findsOneWidget);
  });

  testWidgets('privacy notice explains data use and rights; falls back to '
      'support when no grievance contact is configured', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    await h.start(t);
    await goTo(t, Routes.privacyNotice);
    expect(find.text('What we collect'), findsOneWidget);
    expect(find.textContaining('Razorpay'), findsWidgets);
    await t.scrollUntilVisible(
      find.text('Your rights'),
      200,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await t.scrollUntilVisible(
      find.textContaining('contact DRS customer support'),
      200,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    expect(find.text('Read the full privacy policy'), findsNothing);
  });

  testWidgets('configured policy URL and grievance email are offered', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(
      env: DrsEnv.resolve(
        appFlavor: 'prod',
        privacyPolicyUrl: 'https://example.in/privacy',
        grievanceEmail: 'grievance@example.in',
      ),
    );
    await h.start(t);
    await goTo(t, Routes.privacyNotice);
    final list = find.byType(Scrollable).hitTestable().first;
    await t.scrollUntilVisible(
      find.text('Read the full privacy policy'),
      200,
      scrollable: list,
    );
    expect(find.text('grievance@example.in'), findsOneWidget);

    await goTo(t, Routes.about);
    expect(find.text('Build: prod · Live server'), findsOneWidget);
  });
}
