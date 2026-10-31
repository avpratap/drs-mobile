import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/local/app_database.dart';
import 'product_mapper.dart';

/// A catalogue read, tagged with where it came from.
class CatalogueSnapshot {
  const CatalogueSnapshot({
    required this.products,
    required this.fromCache,
    this.fetchedAt,
    this.error,
  });

  final List<Product> products;

  /// True when served from the Drift cache (offline / server error).
  final bool fromCache;
  final DateTime? fetchedAt;

  /// Why the network refresh failed, when [fromCache] is a fallback.
  final DrsApiError? error;

  List<String> get categories {
    final seen = <String>{};
    for (final p in products) {
      final c = p.category?.trim();
      if (c != null && c.isNotEmpty) seen.add(c);
    }
    return seen.toList(growable: false);
  }
}

/// Offline-first catalogue: network → Drift cache; on any failure, the last
/// good snapshot from Drift.
class ProductRepository {
  ProductRepository({
    required this._api,
    required this._db,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final ProductsApi _api;
  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Matches the backend's MAX_LIMIT; the DRS catalogue is far smaller.
  static const pageSize = 200;

  /// The cached catalogue, or null if nothing has been cached yet.
  Future<CatalogueSnapshot?> readCache() async {
    final rows = await _db.cachedCatalogue();
    if (rows.isEmpty) return null;
    return CatalogueSnapshot(
      products: rows.map((r) => r.toDomain()).toList(growable: false),
      fromCache: true,
      fetchedAt: rows.first.fetchedAt,
    );
  }

  /// Fetches from the API and refreshes the cache. Falls back to the cache on
  /// failure; throws [DrsApiError] only when there is nothing cached.
  Future<CatalogueSnapshot> refresh() async {
    try {
      final res = await _api.listProducts(limit: pageSize);
      final products = (res.data ?? const <ProductOut>[])
          .map((p) => p.toDomain())
          .toList(growable: false);
      final now = _clock();
      await _db.replaceCatalogue([
        for (var i = 0; i < products.length; i++)
          products[i].toCacheRow(position: i, fetchedAt: now),
      ]);
      return CatalogueSnapshot(
        products: products,
        fromCache: false,
        fetchedAt: now,
      );
    } on Object catch (e) {
      final error = DrsApiError.from(e);
      final cached = await readCache();
      if (cached == null) throw error;
      return CatalogueSnapshot(
        products: cached.products,
        fromCache: true,
        fetchedAt: cached.fetchedAt,
        error: error,
      );
    }
  }
}
