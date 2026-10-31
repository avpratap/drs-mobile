import 'package:drift/drift.dart' show Value;
import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/local/app_database.dart';

/// Wire DTO (generated) → domain model.
extension ProductOutMapper on ProductOut {
  Product toDomain() => Product(
    id: id,
    sku: sku,
    name: name,
    description: description,
    category: category,
    uom: uom ?? 'piece',
    packSize: (packSize ?? 1).toDouble(),
    fromPrice: fromPrice == null ? null : Money.fromRupees(fromPrice!),
    imageUrl: imageUrl,
    isSubscribable: isSubscribable ?? true,
    perishable: perishable ?? true,
    avgRating: (avgRating ?? 0).toDouble(),
    ratingCount: ratingCount ?? 0,
  );
}

/// Domain ↔ Drift row.
extension ProductCacheMapper on Product {
  CachedProductsCompanion toCacheRow({
    required int position,
    required DateTime fetchedAt,
  }) => CachedProductsCompanion.insert(
    id: Value(id),
    sku: sku,
    name: name,
    description: Value(description),
    category: Value(category),
    uom: uom,
    packSize: packSize,
    fromPricePaise: Value(fromPrice?.paise),
    imageUrl: Value(imageUrl),
    isSubscribable: isSubscribable,
    perishable: perishable,
    avgRating: avgRating,
    ratingCount: ratingCount,
    position: position,
    fetchedAt: fetchedAt,
  );
}

extension CachedProductMapper on CachedProduct {
  Product toDomain() => Product(
    id: id,
    sku: sku,
    name: name,
    description: description,
    category: category,
    uom: uom,
    packSize: packSize,
    fromPrice: fromPricePaise == null ? null : Money.paise(fromPricePaise!),
    imageUrl: imageUrl,
    isSubscribable: isSubscribable,
    perishable: perishable,
    avgRating: avgRating,
    ratingCount: ratingCount,
  );
}
