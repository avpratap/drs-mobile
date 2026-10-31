import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Offline copy of the public product catalogue.
///
/// DPDP note: this database holds catalogue data only. Personal data (phone,
/// name, addresses) and tokens are never written here.
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

@DriftDatabase(tables: [CachedProducts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'drs_customer'));

  @override
  int get schemaVersion => 1;

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
