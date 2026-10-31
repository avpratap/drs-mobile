import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Offline copy of the public product catalogue.
///
/// DPDP note: tokens, phone numbers, names and addresses are never written to
/// this database. The only account-scoped data is [CachedJson] (order history
/// and standing orders, for offline viewing), which is wiped on sign-out by
/// [AppDatabase.clearUserData].
@DataClassName('CachedProduct')
class CachedProducts extends Table {
  IntColumn get id => integer()();
  TextColumn get sku => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get uom => text()();
  RealColumn get packSize => real()();
  IntColumn get fromPricePaise => integer().nullable()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isSubscribable => boolean()();
  BoolColumn get perishable => boolean()();
  RealColumn get avgRating => real()();
  IntColumn get ratingCount => integer()();

  /// Server order, so the offline list looks like the online one.
  IntColumn get position => integer()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Read-through cache of account-scoped API responses (raw JSON of the
/// generated DTOs), keyed e.g. `orders` / `subscriptions`.
class CachedJson extends Table {
  TextColumn get key => text()();
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [CachedProducts, CachedJson])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'drs_customer'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(cachedJson);
    },
  );

  Future<String?> readJson(String key) async => (await (select(
    cachedJson,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.json;

  Future<void> writeJson(String key, String json, DateTime at) =>
      into(cachedJson).insertOnConflictUpdate(
        CachedJsonCompanion.insert(key: key, json: json, fetchedAt: at),
      );

  /// Removes everything tied to the signed-in account (call on sign-out).
  Future<void> clearUserData() => delete(cachedJson).go();

  /// Atomically replaces the cached catalogue with a fresh server snapshot.
  Future<void> replaceCatalogue(List<CachedProductsCompanion> rows) =>
      transaction(() async {
        await delete(cachedProducts).go();
        await batch((b) => b.insertAll(cachedProducts, rows));
      });

  Future<List<CachedProduct>> cachedCatalogue() => (select(
    cachedProducts,
  )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
}
