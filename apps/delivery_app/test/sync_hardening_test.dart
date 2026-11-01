import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:delivery_app/src/data/delivery_database.dart';
import 'package:delivery_app/src/features/sync/sync_controller.dart';
import 'package:delivery_app/src/features/sync/sync_engine.dart';
import 'package:delivery_app/src/routes.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'support/fake_delivery_server.dart';
import 'support/harness.dart';

Future<void> _deliver(WidgetTester t) async {
  await goTo(t, Routes.stop(11));
  await t.tap(find.text('Mark delivered'));
  await t.pumpAndSettle();
  await t.tap(find.text('Take photo'));
  await t.pumpAndSettle();
  await t.ensureVisible(find.text('Confirm delivery'));
  await t.tap(find.text('Confirm delivery'));
  await t.pumpAndSettle();
}

/// Widget tests run on a fake clock: futures that need DB/HTTP work only
/// complete while frames are pumped, so pump until [f] is done.
Future<void> _pumpWhile(WidgetTester t, Future<void> f) async {
  var done = false;
  unawaited(f.whenComplete(() => done = true));
  for (var i = 0; i < 100 && !done; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
  expect(done, isTrue, reason: 'operation did not finish');
  await t.pumpAndSettle();
}

ProviderContainer _container(WidgetTester t) =>
    ProviderScope.containerOf(t.element(find.byType(Navigator).first));

Map<String, Object?> _stop(Harness h, int id) =>
    h.server.orders.firstWhere((o) => o['id'] == id);

void main() {
  group('conflicts', () {
    deliveryTest('office marked the stop failed while the rider delivered '
        'offline: conflict explained, acknowledged, server version shown', (
      t,
      h,
    ) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      h.server.offline = true;
      await _deliver(t);
      _stop(h, 11)['status'] = 'failed';
      h.server.offline = false;
      await goTo(t, Routes.today);
      await t.tap(find.text('Sync now'));
      await t.pumpAndSettle();

      final pending = await h.db.allPending();
      expect(pending.single.state, 'conflict');
      expect(h.server.writesApplied, 0);
      expect(
        find.text('The office changed a stop you updated — open it to review.'),
        findsOneWidget,
      );
      expect(find.text('Failed · changed by office'), findsOneWidget);

      await goTo(t, Routes.stop(11));
      expect(find.text('Changed by the office'), findsOneWidget);
      expect(
        find.textContaining('already marked this stop as failed'),
        findsOneWidget,
      );
      await t.tap(find.text("OK, show the office's version"));
      await t.pumpAndSettle();
      expect(await h.db.allPending(), isEmpty);
      expect(h.files.kept, isEmpty); // queued photo removed
      expect(find.text('Changed by the office'), findsNothing);
    });

    deliveryTest('stop reassigned away (404): conflict, not "rejected"', (
      t,
      h,
    ) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      h.server.offline = true;
      await _deliver(t);
      h.server.orders.removeWhere((o) => o['id'] == 11);
      h.server.offline = false;
      await goTo(t, Routes.today);
      await t.tap(find.text('Sync now'));
      await t.pumpAndSettle();
      final a = (await h.db.allPending()).single;
      expect(a.state, 'conflict');
      expect(a.lastError, contains('no longer on your route'));
    });

    deliveryTest('same outcome already recorded by the server: just done', (
      t,
      h,
    ) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      h.server.offline = true;
      await _deliver(t);
      _stop(h, 11)['status'] = 'delivered';
      h.server.offline = false;
      await goTo(t, Routes.today);
      await t.tap(find.text('Sync now'));
      await t.pumpAndSettle();
      expect(await h.db.allPending(), isEmpty);
      expect(find.textContaining('changed by office'), findsNothing);
    });
  });

  group('retry / backoff', () {
    deliveryTest('server busy: honours Retry-After, automatic runs wait, '
        'then it goes through; the rider is told it will retry', (t, h) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      h.server
        ..failWritesWith = 503
        ..retryAfter = '120';
      await _deliver(t); // sync attempt 1 -> 503
      await goTo(t, Routes.today);
      expect(
        find.textContaining('the server is busy; retrying automatically'),
        findsOneWidget,
      );
      final a = (await h.db.allPending()).single;
      expect(a.nextAttemptAt, DateTime(2026, 11, 1, 8, 2));

      h.server.failWritesWith = null;
      final sync = _container(t).read(syncControllerProvider.notifier);
      final before = h.server
          .callsTo('POST /api/v1/delivery/orders/11/deliver')
          .length;
      await _pumpWhile(t, sync.syncNow()); // automatic tick, not due yet
      expect(
        h.server.callsTo('POST /api/v1/delivery/orders/11/deliver').length,
        before,
      );

      h.now = DateTime(2026, 11, 1, 8, 3);
      await _pumpWhile(t, sync.syncNow());
      expect(h.server.writesApplied, 1);
      expect(await h.db.allPending(), isEmpty);
    });

    deliveryTest('"Sync now" retries immediately despite backoff', (
      t,
      h,
    ) async {
      setDevice(t, const Size(412, 915));
      await h.start(t);
      h.server.failWritesWith = 500;
      await _deliver(t);
      expect((await h.db.allPending()).single.nextAttemptAt, isNotNull);
      h.server.failWritesWith = null;
      await goTo(t, Routes.today);
      await t.tap(find.text('Sync now'));
      await t.pumpAndSettle();
      expect(h.server.writesApplied, 1);
    });
  });

  test('a later action for a stop never overtakes one that is backing off; '
      'other stops still sync', () async {
    final server = FakeDeliveryServer();
    final db = DeliveryDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final tokens = InMemoryTokenStore(
      const SessionTokens(accessToken: 'a', refreshToken: 'r'),
    );
    final api = buildDrsApi(
      baseUrl: 'http://test',
      tokenStore: tokens,
      httpClientAdapter: server,
    ).getDeliveryApi();
    final now = DateTime(2026, 11, 1, 8);
    Future<void> add(String id, int order, String kind, {DateTime? next}) =>
        db.enqueue(
          PendingActionsCompanion.insert(
            id: id,
            orderId: order,
            kind: kind,
            payload: jsonEncode({
              'date': '2026-11-01',
              'reason': 'customer_unavailable',
            }),
            createdAt: now.add(Duration(seconds: id.codeUnitAt(0))),
            nextAttemptAt: Value(next),
          ),
        );
    await add('a', 11, 'fail', next: now.add(const Duration(minutes: 5)));
    await add('b', 11, 'fail');
    await add('c', 12, 'fail');
    final engine = SyncEngine(
      api: api,
      db: db,
      files: FakePodFiles(),
      clock: () => now,
      random: Random(1),
    );
    expect(await engine.run(), SyncOutcome.done);
    expect(server.calls.map((c) => c.path), [
      '/api/v1/delivery/orders/12/fail',
    ]);
    expect((await db.allPending()).map((a) => a.id), ['a', 'b']);
  });

  test('upgrading the on-device database keeps queued actions (v1 -> v2)', () async {
    final db = DeliveryDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw
            ..execute(
              'CREATE TABLE cached_json (key TEXT NOT NULL, json TEXT NOT '
              'NULL, fetched_at INTEGER NOT NULL, PRIMARY KEY (key))',
            )
            ..execute(
              'CREATE TABLE pending_actions (id TEXT NOT NULL, order_id '
              'INTEGER NOT NULL, kind TEXT NOT NULL, payload TEXT NOT NULL, '
              'photo_path TEXT NULL, photo_ref TEXT NULL, state TEXT NOT NULL '
              "DEFAULT 'queued', attempts INTEGER NOT NULL DEFAULT 0, "
              'last_error TEXT NULL, created_at INTEGER NOT NULL, '
              'PRIMARY KEY (id))',
            )
            ..execute(
              'INSERT INTO pending_actions (id, order_id, kind, payload, '
              "created_at) VALUES ('x', 11, 'fail', '{}', 1793520000)",
            )
            ..execute('PRAGMA user_version = 1');
        },
      ),
    );
    addTearDown(db.close);
    final rows = await db.allPending();
    expect(rows.single.id, 'x');
    expect(rows.single.nextAttemptAt, isNull);
    await db.recordAttempt(
      'x',
      'busy',
      nextAttemptAt: DateTime(2026, 11, 1, 9),
    );
    expect((await db.allPending()).single.attempts, 1);
  });
}
