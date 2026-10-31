import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:drift/drift.dart' show Value;
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers.dart';
import '../../data/delivery_database.dart';
import '../route/route_providers.dart';
import '../route/route_repository.dart';
import 'sync_engine.dart';

part 'sync_controller.g.dart';

/// How queued photos are read for upload (overridden in tests).
@Riverpod(keepAlive: true)
Future<MultipartFile> Function(String path)? podPhotoReader(Ref ref) => null;

@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) => SyncEngine(
  api: ref.watch(drsApiProvider).getDeliveryApi(),
  db: ref.watch(deliveryDatabaseProvider),
  files: ref.watch(podFilesProvider),
  readPhoto: ref.watch(podPhotoReaderProvider),
);

class SyncStatus {
  const SyncStatus({this.running = false, this.offline = false, this.lastRun});

  final bool running;

  /// The last run stopped because the server was unreachable.
  final bool offline;
  final DateTime? lastRun;
}

/// Records rider actions locally (instant, works offline) and syncs them.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  static const _uuid = Uuid();

  @override
  SyncStatus build() => const SyncStatus();

  DeliveryDatabase get _db => ref.read(deliveryDatabaseProvider);

  /// Mark delivered. [delivered] maps product id → delivered qty (0 = not
  /// delivered); every planned line must be present (backend rule).
  Future<void> deliver(
    DeliveryStop stop, {
    required Map<int, double> delivered,
    String? photoPath,
    String? note,
  }) async {
    final id = _uuid.v4();
    final kept = photoPath == null
        ? null
        : await ref.read(podFilesProvider).keep(photoPath, id);
    await _db.enqueue(
      PendingActionsCompanion.insert(
        id: id,
        orderId: stop.orderId,
        kind: 'deliver',
        payload: jsonEncode({
          'date': dateKey(stop.deliveryDate),
          'items': [
            for (final e in delivered.entries)
              {'product_id': e.key, 'qty_delivered': e.value},
          ],
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
        }),
        photoPath: Value(kept),
        createdAt: DateTime.now(),
      ),
    );
    unawaited(syncNow());
  }

  Future<void> fail(DeliveryStop stop, FailReason reason) async {
    await _db.enqueue(
      PendingActionsCompanion.insert(
        id: _uuid.v4(),
        orderId: stop.orderId,
        kind: 'fail',
        payload: jsonEncode({
          'date': dateKey(stop.deliveryDate),
          'reason': reason.wire,
        }),
        createdAt: DateTime.now(),
      ),
    );
    unawaited(syncNow());
  }

  /// Runs the queue; when anything synced, re-reads the route so statuses
  /// come from the server again.
  Future<void> syncNow() async {
    if (state.running) return;
    final before = (await _db.allPending()).length;
    if (before == 0) return;
    state = SyncStatus(running: true, lastRun: state.lastRun);
    final outcome = await ref.read(syncEngineProvider).run();
    final after = (await _db.allPending()).length;
    if (!ref.mounted) return;
    state = SyncStatus(
      offline: outcome == SyncOutcome.offline,
      lastRun: DateTime.now(),
    );
    if (after < before) ref.invalidate(routeProvider);
  }

  /// Puts a failed action back in the queue (after the rider checked it).
  Future<void> retry(String id) async {
    await _db.requeue(id);
    await syncNow();
  }

  /// Drops a failed action (the stop becomes actionable again).
  Future<void> discard(QueuedAction a) async {
    await _db.remove(a.id);
    await ref.read(podFilesProvider).discard(a.photoPath);
  }
}
