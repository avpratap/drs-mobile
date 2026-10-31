import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/mappers.dart';

/// Server-side cart (`/api/v1/cart`). Every mutation returns the full cart as
/// re-priced by the server, so the UI never computes money itself.
class CartRepository {
  CartRepository(this._api);

  final CartApi _api;

  Future<Cart> fetch() =>
      guard(() async => (await _api.getCart()).data!.toDomain());

  /// Adds [qty] (in the product's uom) — the backend merges into the product's
  /// existing line.
  Future<Cart> add(int productId, double qty) => guard(
    () async => (await _api.addCartItem(
      cartItemIn: CartItemIn(productId: productId, qty: qty),
    )).data!.toDomain(),
  );

  Future<Cart> setQty(int itemId, double qty) => guard(
    () async => (await _api.setCartItemQty(
      itemId: itemId,
      cartItemQtyIn: CartItemQtyIn(qty: qty),
    )).data!.toDomain(),
  );

  Future<Cart> remove(int itemId) => guard(
    () async => (await _api.removeCartItem(itemId: itemId)).data!.toDomain(),
  );

  /// GST breakdown + (with a pincode) serviceability.
  Future<CartQuote> quote({String? pincode}) => guard(
    () async =>
        (await _api.cartQuote(quoteIn: QuoteIn(pincode: pincode))).data!
            .toDomain(),
  );
}
