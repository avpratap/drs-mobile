import 'package:delivery_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Future<void> _deliver(
  WidgetTester t, {
  bool uncheckButtermilk = false,
  String? note,
}) async {
  await goTo(t, Routes.stop(11));
  await t.tap(find.text('Mark delivered'));
  await t.pumpAndSettle();
  // Photo is required before confirming.
  expect(
    t
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Confirm delivery'),
        )
        .onPressed,
    isNull,
  );
  if (uncheckButtermilk) {
    await t.tap(find.text('Masala Buttermilk'));
    await t.pump();
  }
  await t.tap(find.text('Take photo'));
  await t.pumpAndSettle();
  expect(find.text('Retake photo'), findsOneWidget);
  if (note != null) {
    await t.enterText(find.widgetWithText(TextField, 'Note (optional)'), note);
  }
  await t.ensureVisible(find.text('Confirm delivery'));
  await t.tap(find.text('Confirm delivery'));
  await t.pumpAndSettle();
}

void main() {
  deliveryTest('online POD: photo uploaded once, deliver sent with the '
      'idempotency key, media ref, note and every planned line', (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    await _deliver(t, uncheckButtermilk: true, note: 'Left with security');

    expect(h.server.uploads, 1);
    final call = h.server
        .callsTo('POST /api/v1/delivery/orders/11/deliver')
        .single;
    expect(call.headers['Idempotency-Key'], isNotEmpty);
    expect(call.body, {
      'items': [
        {'product_id': 2, 'qty_delivered': 1},
        {'product_id': 3, 'qty_delivered': 0},
      ],
      'pod': {
        'photo_url': 'media:pod/3/abc1.jpg',
        'note': 'Left with security',
      },
    });
    // Queue drained, local photo deleted, server state shown.
    expect(await h.db.allPending(), isEmpty);
    expect(h.files.kept, isEmpty);
    expect(find.text('Partly delivered'), findsOneWidget);
    expect(find.text('2 of 3 delivered'), findsOneWidget);
  });

  deliveryTest('offline POD is queued in Drift, shown as syncing, and synced '
      'when back online', (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    h.server.offline = true;
    await _deliver(t);

    expect(find.text('Delivered · syncing'), findsOneWidget);
    expect(
      find.textContaining('1 update(s) waiting to sync — offline'),
      findsOneWidget,
    );
    final queued = await h.db.allPending();
    expect(queued.single.orderId, 11);
    expect(queued.single.photoRef, isNull);
    expect(h.files.kept, hasLength(1));

    h.server.offline = false;
    await t.tap(find.text('Sync now'));
    await t.pumpAndSettle();
    expect(await h.db.allPending(), isEmpty);
    expect(h.server.writesApplied, 1);
    expect(find.text('2 of 3 delivered'), findsOneWidget);
    expect(find.textContaining('waiting to sync'), findsNothing);
  });

  deliveryTest('lost response: retry replays with the SAME key — applied once, '
      'photo uploaded once', (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    h.server.loseNextWriteResponse = true;
    await _deliver(t);

    // Applied on the server but the app never heard back → still queued,
    // with the uploaded media ref persisted.
    expect(h.server.writesApplied, 1);
    final queued = (await h.db.allPending()).single;
    expect(queued.photoRef, 'media:pod/3/abc1.jpg');

    await t.tap(find.text('Sync now'));
    await t.pumpAndSettle();
    final keys = h.server
        .callsTo('POST /api/v1/delivery/orders/11/deliver')
        .map((c) => c.headers['Idempotency-Key'])
        .toSet();
    expect(keys, hasLength(1));
    expect(h.server.writesApplied, 1);
    expect(h.server.uploads, 1);
    expect(await h.db.allPending(), isEmpty);
  });

  deliveryTest('409 for a stop the server already closed is reconciled, not '
      'retried forever', (t, h) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    h.server.offline = true;
    await _deliver(t);
    // Meanwhile the stop was closed elsewhere (and the idempotency window passed).
    h.server.orders.firstWhere((o) => o['id'] == 11)['status'] = 'delivered';
    h.server.offline = false;
    await t.tap(find.text('Sync now'));
    await t.pumpAndSettle();
    expect(await h.db.allPending(), isEmpty);
  });

  deliveryTest('a rejected update needs attention; rider can discard it', (
    t,
    h,
  ) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    h.server.offline = true;
    await _deliver(t);
    // Server-side plan changed: a new planned line the device didn't report.
    (h.server.orders.firstWhere((o) => o['id'] == 11)['items']! as List).add({
      'product_id': 9,
      'qty_planned': 1,
      'qty_delivered': 0,
      'unit_price': 1,
      'line_total': 1,
      'status': 'planned',
    });
    h.server.offline = false;
    await t.tap(find.text('Sync now'));
    await t.pumpAndSettle();
    expect(find.textContaining('need your attention'), findsOneWidget);
    expect(find.text('Needs attention'), findsOneWidget);

    await goTo(t, Routes.stop(11));
    expect(
      find.text('Delivery must report every planned item'),
      findsOneWidget,
    );
    await t.tap(find.text('Discard'));
    await t.pumpAndSettle();
    expect(await h.db.allPending(), isEmpty);
    expect(find.text('Mark delivered'), findsOneWidget);
  });

  deliveryTest("couldn't deliver: reason sheet → fail with wire reason", (
    t,
    h,
  ) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    await goTo(t, Routes.stop(12));
    await t.tap(find.text("Couldn't deliver"));
    await t.pumpAndSettle();
    await t.tap(find.text('Customer unavailable'));
    await t.pumpAndSettle();
    final call = h.server
        .callsTo('POST /api/v1/delivery/orders/12/fail')
        .single;
    expect(call.body, {'reason': 'customer_unavailable'});
    expect(call.headers['Idempotency-Key'], isNotEmpty);
    expect(find.text('Failed'), findsOneWidget);
  });

  deliveryTest('log out warns about unsynced updates and wipes local data', (
    t,
    h,
  ) async {
    setDevice(t, const Size(412, 915));
    await h.start(t);
    h.server.offline = true;
    await _deliver(t);
    await t.tap(find.byTooltip('More'));
    await t.pumpAndSettle();
    await t.tap(find.text('Log out'));
    await t.pumpAndSettle();
    expect(find.textContaining('1 update(s) have not synced'), findsOneWidget);
    await t.tap(find.text('Log out').last);
    await t.pumpAndSettle();
    expect(find.text('Rider login'), findsOneWidget);
    expect(await h.db.allPending(), isEmpty);
    expect(await h.db.readJson('route:2026-11-01'), isNull);
    expect(h.files.wiped, 1);
  });
}
