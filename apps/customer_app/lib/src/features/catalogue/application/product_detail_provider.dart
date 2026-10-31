import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../../data/api_guard.dart';
import '../../../data/mappers.dart';
import 'catalogue_providers.dart';

part 'product_detail_provider.g.dart';

/// id → product from the (cached) catalogue, to name cart / order /
/// subscription lines that only carry a product id.
@riverpod
Map<int, Product> productIndex(Ref ref) => {
  for (final p
      in ref.watch(catalogueProvider).value?.products ?? const <Product>[])
    p.id: p,
};

/// Product page with pack sizes. Offline, falls back to the cached catalogue
/// entry with its default pack (adding to cart still needs the network).
@riverpod
Future<ProductDetail> productDetail(Ref ref, int productId) async {
  try {
    return await guard(
      () async =>
          (await ref
                  .watch(drsApiProvider)
                  .getProductsApi()
                  .getProductFull(productId: productId))
              .data!
              .toDomain(),
    );
  } on DrsApiError catch (e) {
    final cached = ref.read(productIndexProvider)[productId];
    if (!e.isConnectivity || cached == null) rethrow;
    return ProductDetail(
      product: cached,
      packs: [
        Pack(
          packSize: cached.packSize,
          label: cached.packLabel,
          price: cached.fromPrice,
        ),
      ],
    );
  }
}
