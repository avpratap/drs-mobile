import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'delivery_database.g.dart';

/// Read-through cache of API responses (route per day, product names).
class CachedJson extends Table {
  TextColumn get key => text()();
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// A rider action taken on the device and not yet confirmed by the server.
///
/// [id] doubles as the `Idempotency-Key`, so a retry after a lost response is
/// replayed by the backend instead of applied twice. [photoRef] is set once
/// the POD photo is uploaded, so a retry never uploads it again.
@DataClassName('PendingAction')
class PendingActions extends Table {
  TextColumn get id => text()();
  IntColumn get orderId => integer()();

  /// `deliver` | `fail`
  TextColumn get kind => text()();

  /// JSON: items / note / reason / date.
  TextColumn get payload => text()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get photoRef => text().nullable()();

  /// `queued` (will be retried automatically) | `failed` (needs the rider).
  TextColumn get state => text().withDefault(const Constant('queued'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Plain view of a [PendingAction] row for the UI / providers (generated
/// Drift classes can't appear in riverpod_generator signatures).
class QueuedAction {
  const QueuedAction({
    required this.id,
    required this.orderId,
    required this.kind,
    required this.state,
    required this.attempts,
    this.lastError,
    this.photoPath,
  });

  final String id;
  final int orderId;

  /// `deliver` | `fail`
  final String kind;

  /// `queued` | `failed`
  final String state;
  final int attempts;
  final String? lastError;
  final String? photoPath;
}

/// DPDP: tokens are never stored here. Route/contact data and queued POD
/// photos are kept only as long as needed and wiped on sign-out ([clearAll]).
@DriftDatabase(tables: [CachedJson, PendingActions])
class DeliveryDatabase extends _$DeliveryDatabase {
  DeliveryDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'drs_delivery'));

  @override
  int get schemaVersion => 1;

  Future<String?> readJson(String key) async => (await (select(
    cachedJson,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.json;

  Future<void> writeJson(String key, String json, DateTime at) =>
      into(cachedJson).insertOnConflictUpdate(
        CachedJsonCompanion.insert(key: key, json: json, fetchedAt: at),
      );

  Future<void> enqueue(PendingActionsCompanion action) =>
      into(pendingActions).insert(action);

  /// Oldest first.
  Stream<List<QueuedAction>> watchPending() =>
      (select(
        pendingActions,
      )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).watch().map(
        (rows) => [
          for (final r in rows)
            QueuedAction(
              id: r.id,
              orderId: r.orderId,
              kind: r.kind,
              state: r.state,
              attempts: r.attempts,
              lastError: r.lastError,
              photoPath: r.photoPath,
            ),
        ],
      );

  Future<List<PendingAction>> queued() =>
      (select(pendingActions)
            ..where((t) => t.state.equals('queued'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<PendingAction>> allPending() => select(pendingActions).get();

  Future<void> setPhotoRef(String id, String ref) =>
      (update(pendingActions)..where((t) => t.id.equals(id))).write(
        PendingActionsCompanion(photoRef: Value(ref)),
      );

  Future<void> recordAttempt(String id, String error, {required bool failed}) =>
      customUpdate(
        'UPDATE pending_actions SET attempts = attempts + 1, last_error = ?, '
        'state = ? WHERE id = ?',
        variables: [
          Variable.withString(error),
          Variable.withString(failed ? 'failed' : 'queued'),
          Variable.withString(id),
        ],
        updates: {pendingActions},
      );

  Future<void> requeue(String id) =>
      (update(pendingActions)..where((t) => t.id.equals(id))).write(
        const PendingActionsCompanion(state: Value('queued')),
      );

  Future<void> remove(String id) =>
      (delete(pendingActions)..where((t) => t.id.equals(id))).go();

  Future<void> clearAll() => transaction(() async {
    await delete(cachedJson).go();
    await delete(pendingActions).go();
  });
}
