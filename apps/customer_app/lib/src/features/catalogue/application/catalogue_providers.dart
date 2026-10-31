import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/product_repository.dart';

part 'catalogue_providers.g.dart';

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) => ProductRepository(
  api: ref.watch(drsApiProvider).getProductsApi(),
  db: ref.watch(appDatabaseProvider),
);

/// Stale-while-revalidate catalogue: emits the Drift cache immediately (if
/// any), then the network result (or the cache again, flagged offline).
@Riverpod(keepAlive: true)
Stream<CatalogueSnapshot> catalogue(Ref ref) async* {
  final repo = ref.watch(productRepositoryProvider);
  final cached = await repo.readCache();
  if (cached != null) yield cached;
  yield await repo.refresh();
}
