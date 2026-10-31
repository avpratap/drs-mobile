import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/seed.dart';

Finder _field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  group('profile', () {
    testWidgets('opens from Account; masked phone; saves changed fields only', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final h = Harness();
      await h.start(t);
      await goTo(t, Routes.account);
      await t.tap(find.text('Asha Devi'));
      await t.pumpAndSettle();

      expect(find.text('Your profile'), findsOneWidget);
      expect(find.text('+91 98•••••210'), findsOneWidget);
      expect(find.textContaining('9876543210'), findsNothing);
      expect(find.text('Verified'), findsOneWidget);

      await t.enterText(_field('Full name'), 'Asha Sharma');
      await t.tap(find.text('Save'));
      await t.pumpAndSettle();

      final patch = h.server.callsTo('PATCH /api/v1/profile').single;
      expect(patch.body, {'full_name': 'Asha Sharma'});
      expect(find.text('Profile saved'), findsOneWidget);
    });

    testWidgets('changing email needs re-verification; bad email blocked', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final h = Harness();
      await h.start(t);
      await goTo(t, Routes.profile);

      await t.enterText(_field('Email (optional)'), 'asha@drs.in');
      await t.pump();
      expect(
        find.text('You’ll need to verify the new address.'),
        findsOneWidget,
      );

      await t.enterText(_field('Email (optional)'), 'not-an-email');
      await t.tap(find.text('Save'));
      await t.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(h.server.callsTo('PATCH /api/v1/profile'), isEmpty);

      await t.enterText(_field('Email (optional)'), 'asha@drs.in');
      await t.tap(find.text('Save'));
      await t.pumpAndSettle();
      expect(h.server.callsTo('PATCH /api/v1/profile').single.body, {
        'email': 'asha@drs.in',
      });
      expect(find.text('Not verified'), findsOneWidget);
    });
  });

  group('addresses', () {
    testWidgets('add, edit, set default and delete', (t) async {
      setDevice(t, const Size(412, 915));
      final h = Harness(server: seededServer());
      await h.start(t);
      await goTo(t, Routes.addresses);
      expect(find.text('Default'), findsOneWidget);

      // Add.
      await t.tap(find.text('Add address'));
      await t.pumpAndSettle();
      await t.enterText(_field('House / flat, street'), '4 MI Road');
      await t.enterText(_field('City'), 'Jaipur');
      await t.tap(find.text('State'));
      await t.pumpAndSettle();
      await t.scrollUntilVisible(
        find.text('Rajasthan').hitTestable(),
        200,
        scrollable: find.byType(Scrollable).last, // the open dropdown menu
      );
      await t.tap(find.text('Rajasthan').hitTestable().last);
      await t.pumpAndSettle();
      await t.enterText(_field('PIN code'), '302002');
      await t.enterText(_field('Save as'), 'Office');
      await t.ensureVisible(find.text('Save address'));
      await t.tap(find.text('Save address'));
      await t.pumpAndSettle();
      expect(h.server.addresses, hasLength(2));
      expect(find.text('Office'), findsOneWidget);

      // Edit.
      await t.tap(find.byTooltip('Address options').last);
      await t.pumpAndSettle();
      await t.tap(find.text('Edit'));
      await t.pumpAndSettle();
      expect(find.text('Edit address'), findsOneWidget);
      expect(find.text('4 MI Road'), findsOneWidget);
      await t.enterText(_field('House / flat, street'), '5 MI Road');
      await t.ensureVisible(find.text('Save changes'));
      await t.tap(find.text('Save changes'));
      await t.pumpAndSettle();
      expect(h.server.callsTo('PATCH /api/v1/addresses/2'), hasLength(1));
      expect(h.server.addresses.last['line1'], '5 MI Road');
      expect(find.textContaining('5 MI Road'), findsOneWidget);

      // New addresses default to "use as default".
      expect(h.server.addresses.last['is_default'], isTrue);
      expect(h.server.addresses.first['is_default'], isFalse);

      // Set the original one back as default.
      await t.tap(find.byTooltip('Address options').first);
      await t.pumpAndSettle();
      await t.tap(find.text('Set as default'));
      await t.pumpAndSettle();
      expect(
        h.server.callsTo('POST /api/v1/addresses/1/default'),
        hasLength(1),
      );
      expect(h.server.addresses.first['is_default'], isTrue);
      expect(h.server.addresses.last['is_default'], isFalse);

      // Delete (confirmed).
      await t.tap(find.byTooltip('Address options').last);
      await t.pumpAndSettle();
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();
      expect(find.text('Delete this address?'), findsOneWidget);
      await t.tap(find.text('Delete').last);
      await t.pumpAndSettle();
      expect(h.server.callsTo('DELETE /api/v1/addresses/2'), hasLength(1));
      expect(find.textContaining('5 MI Road'), findsNothing);
      expect(h.server.addresses, hasLength(1));
    });
  });

  group('notification preferences', () {
    testWidgets('categories persist to profile and the consent ledger', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final push = FakePushPlatform();
      final h = Harness(push: push);
      await h.start(t);
      await goTo(t, Routes.account);
      await t.tap(find.text('Notifications'));
      await t.pumpAndSettle();

      expect(find.text('This device'), findsOneWidget);
      final service = find.byKey(const ValueKey('pref-service'));
      final offers = find.byKey(const ValueKey('pref-offers'));
      expect(t.widget<SwitchListTile>(service).value, isTrue);
      expect(t.widget<SwitchListTile>(offers).value, isFalse);

      await t.tap(offers);
      await t.pumpAndSettle();
      expect(h.server.consents, {ConsentPurpose.marketingPush: 'granted'});
      expect(t.widget<SwitchListTile>(offers).value, isTrue);

      await t.tap(service);
      await t.pumpAndSettle();
      expect(h.server.callsTo('PATCH /api/v1/profile').single.body, {
        'notify_push': false,
      });
      expect(t.widget<SwitchListTile>(service).value, isFalse);

      // Withdraw marketing consent again.
      await t.tap(offers);
      await t.pumpAndSettle();
      expect(h.server.consents[ConsentPurpose.marketingPush], 'withdrawn');
    });

    testWidgets('device switch drives the M4 push consent and token', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final push = FakePushPlatform();
      final h = Harness(push: push);
      await h.start(t);
      await goTo(t, Routes.notificationPrefs);
      expect(find.textContaining('Push is off on this device'), findsOneWidget);

      await t.tap(find.byType(Switch).first);
      await t.pumpAndSettle();
      expect(await h.pushPrefs.consent(), isTrue);
      expect(h.server.deviceTokens, hasLength(1));
      expect(
        find.text('These apply to every device you sign in on.'),
        findsOneWidget,
      );

      await t.tap(find.byType(Switch).first);
      await t.pumpAndSettle();
      expect(await h.pushPrefs.consent(), isFalse);
      expect(h.server.deviceTokens, isEmpty);
    });

    testWidgets('a failed save reverts the switch and explains', (t) async {
      setDevice(t, const Size(412, 915));
      final h = Harness();
      await h.start(t);
      await goTo(t, Routes.notificationPrefs);
      h.server.offline = true;
      final offers = find.byKey(const ValueKey('pref-offers'));
      await t.tap(offers);
      await t.pumpAndSettle();
      expect(t.widget<SwitchListTile>(offers).value, isFalse);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
