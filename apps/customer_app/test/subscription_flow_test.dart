import 'package:customer_app/src/features/subscriptions/application/subscription_providers.dart';
import 'package:customer_app/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Map<String, Object?> _address() => {
  'id': 1,
  'account_id': 1,
  'label': 'Home',
  'line1': '12 Gandhi Path',
  'city': 'Jaipur',
  'state': 'Rajasthan',
  'pincode': '302001',
  'country': 'IN',
  'is_default': true,
  'status': 'active',
};

void main() {
  test('cutoff: tomorrow is editable before 23:00 IST, not after', () {
    // 17:00 UTC = 22:30 IST on Oct 31 → Nov 1 still editable.
    expect(
      firstEditableDate(DateTime.utc(2026, 10, 31, 17)),
      DateTime.utc(2026, 11, 1),
    );
    // 17:31 UTC = 23:01 IST → tomorrow frozen, first editable is Nov 2.
    expect(
      firstEditableDate(DateTime.utc(2026, 10, 31, 17, 31)),
      DateTime.utc(2026, 11, 2),
    );
    expect(
      tomorrowIst(DateTime.utc(2026, 10, 31, 19)),
      DateTime.utc(2026, 11, 2),
    );
  });

  testWidgets('create a weekly standing order, then pause / resume / skip a '
      'day / cancel', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    h.server.addresses.add(_address());
    await h.start(t);
    await goTo(t, Routes.subscriptions);

    expect(find.text('Daily deliveries, your way'), findsOneWidget);
    await t.tap(find.text('Choose products'));
    await t.pumpAndSettle();
    // Only subscribable products, milk line first.
    expect(find.text('A2 Desi Ghee'), findsNothing);
    await t.tap(find.text('Cow Milk'));
    await t.pumpAndSettle();

    // 1 L × 2 packs, Mon/Wed/Fri.
    await t.tap(find.text('1 L'));
    await t.tap(find.byTooltip('Increase').first);
    await t.tap(find.text('Weekdays'));
    await t.pumpAndSettle();
    expect(find.text('Pick at least one day.'), findsOneWidget);
    for (final d in ['Mon', 'Wed', 'Fri']) {
      await t.tap(find.text(d));
    }
    await t.pump();
    // First subscription → delivery address shown (default preselected).
    expect(find.text('Deliver to'), findsOneWidget);
    await t.scrollUntilVisible(
      find.text('Start standing order'),
      150,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .last,
    );
    await t.tap(find.text('Start standing order'));
    await t.pumpAndSettle();

    final create = h.server.callsTo('POST /api/v1/subscriptions').single;
    expect(create.body, containsPair('home_pincode', '302001'));
    final items = h.server
        .callsTo('PUT /api/v1/subscriptions/5/items')
        .single
        .body;
    expect(items, [
      {
        'product_id': 2,
        'default_qty': 2,
        'frequency': 'weekly',
        'days_of_week': '1,3,5',
      },
    ]);

    // Back on the tab with the template + tomorrow's plan.
    expect(find.text('Home delivery'), findsOneWidget);
    expect(find.text('2 L · Mon, Wed, Fri'), findsOneWidget);
    expect(find.text('Cow Milk 2 L'), findsOneWidget);

    await t.tap(find.text('Pause'));
    await t.pumpAndSettle();
    expect(find.text('Paused'), findsOneWidget);
    expect(find.text('Skip a day'), findsNothing);
    await t.tap(find.text('Resume'));
    await t.pumpAndSettle();
    expect(find.text('Active'), findsOneWidget);

    // Skip a day: the date picker starts at the first editable day.
    await t.tap(find.text('Skip a day'));
    await t.pumpAndSettle();
    await t.tap(find.text('OK'));
    await t.pumpAndSettle();
    final first = firstEditableDate();
    final day =
        '${first.year}-${first.month.toString().padLeft(2, '0')}-'
        '${first.day.toString().padLeft(2, '0')}';
    expect(h.server.overrides, ['2@$day:0']);
    expect(find.textContaining('skipped'), findsOneWidget);

    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    await t.tap(find.text('Cancel subscription'));
    await t.pumpAndSettle();
    expect(h.server.subscription!['status'], 'cancelled');
    expect(find.text('Daily deliveries, your way'), findsOneWidget);
  });

  testWidgets('standing order is viewable offline from the Drift cache', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    h.server.subscription = {
      'id': 5,
      'shop_id': 9,
      'account_id': 1,
      'status': 'active',
      'start_date': '2026-10-31',
      'items': [
        {
          'id': 1,
          'product_id': 2,
          'default_qty': 1,
          'frequency': 'daily',
          'active': true,
        },
      ],
    };
    await h.start(t);
    await goTo(t, Routes.subscriptions);
    expect(find.text('1 L · Every day'), findsOneWidget);

    h.server.offline = true;
    await t.fling(
      find.byType(Scrollable).hitTestable().first,
      const Offset(0, 400),
      1000,
    );
    await t.pumpAndSettle();
    expect(
      find.text("You're offline — saved information is shown where available."),
      findsOneWidget,
    );
    expect(find.text('1 L · Every day'), findsOneWidget);
    // Mutations are disabled offline.
    expect(
      t
          .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Pause'))
          .onPressed,
      isNull,
    );
  });
}
