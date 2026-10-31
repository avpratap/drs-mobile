import 'dart:async';

import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../auth/application/auth_controller.dart';
import '../data/cart_repository.dart';

part 'cart_providers.g.dart';

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) =>
    CartRepository(ref.watch(drsApiProvider).getCartApi());

/// The signed-in user's server cart. Mutations are serialised (one request
/// in flight at a time) so quick taps on a stepper can't race each other, and
/// state only ever holds what the server returned.
@Riverpod(keepAlive: true)
class CartController extends _$CartController {
  Future<void> _tail = Future<void>.value();

  @override
  Future<Cart> build() async {
    final auth = ref.watch(authControllerProvider).value;
    if (auth is! SignedIn) return Cart.empty;
    return ref.watch(cartRepositoryProvider).fetch();
  }

  Future<void> _mutate(Future<Cart> Function(CartRepository repo) op) {
    final done = Completer<void>();
    _tail = _tail.then((_) async {
      try {
        final cart = await op(ref.read(cartRepositoryProvider));
        if (ref.mounted) state = AsyncData(cart);
        done.complete();
      } on Object catch (e, s) {
        done.completeError(e, s);
      }
    });
    return done.future;
  }

  /// Adds [packs] packs of [pack] (the backend merges into the product line).
  Future<void> addPacks(int productId, Pack pack, int packs) =>
      _mutate((r) => r.add(productId, qtyFor(packs, pack.packSize)));

  /// Sets a line to [packs] × [packSize]; 0 removes it.
  Future<void> setPacks(CartLine line, int packs, double packSize) => _mutate(
    (r) => packs <= 0
        ? r.remove(line.itemId)
        : r.setQty(line.itemId, qtyFor(packs, packSize)),
  );

  Future<void> remove(CartLine line) => _mutate((r) => r.remove(line.itemId));

  /// Re-reads the server cart (e.g. after checkout converted it).
  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

/// Number of distinct products in the cart, for the header badge.
@riverpod
int cartCount(Ref ref) =>
    ref.watch(cartControllerProvider).value?.lineCount ?? 0;

/// Server GST breakdown for the current cart (+ serviceability for
/// [pincode]). Recomputed whenever the cart changes.
@riverpod
Future<CartQuote> cartQuote(Ref ref, {String? pincode}) async {
  final cart = await ref.watch(cartControllerProvider.future);
  if (cart.isEmpty) {
    return const CartQuote(
      subtotal: Money.zero,
      discount: Money.zero,
      taxTotal: Money.zero,
      total: Money.zero,
    );
  }
  return ref.watch(cartRepositoryProvider).quote(pincode: pincode);
}
