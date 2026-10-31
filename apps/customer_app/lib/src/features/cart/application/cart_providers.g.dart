// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartRepository)
final cartRepositoryProvider = CartRepositoryProvider._();

final class CartRepositoryProvider
    extends $FunctionalProvider<CartRepository, CartRepository, CartRepository>
    with $Provider<CartRepository> {
  CartRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartRepositoryHash();

  @$internal
  @override
  $ProviderElement<CartRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartRepository create(Ref ref) {
    return cartRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartRepository>(value),
    );
  }
}

String _$cartRepositoryHash() => r'1753beb58695c8ed39d5d4b45d62416e3aa9ac86';

/// The signed-in user's server cart. Mutations are serialised (one request
/// in flight at a time) so quick taps on a stepper can't race each other, and
/// state only ever holds what the server returned.

@ProviderFor(CartController)
final cartControllerProvider = CartControllerProvider._();

/// The signed-in user's server cart. Mutations are serialised (one request
/// in flight at a time) so quick taps on a stepper can't race each other, and
/// state only ever holds what the server returned.
final class CartControllerProvider
    extends $AsyncNotifierProvider<CartController, Cart> {
  /// The signed-in user's server cart. Mutations are serialised (one request
  /// in flight at a time) so quick taps on a stepper can't race each other, and
  /// state only ever holds what the server returned.
  CartControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartControllerHash();

  @$internal
  @override
  CartController create() => CartController();
}

String _$cartControllerHash() => r'099f19ccaf98d8cb57feff010d18a633db1945fd';

/// The signed-in user's server cart. Mutations are serialised (one request
/// in flight at a time) so quick taps on a stepper can't race each other, and
/// state only ever holds what the server returned.

abstract class _$CartController extends $AsyncNotifier<Cart> {
  FutureOr<Cart> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Cart>, Cart>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Cart>, Cart>,
              AsyncValue<Cart>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Number of distinct products in the cart, for the header badge.

@ProviderFor(cartCount)
final cartCountProvider = CartCountProvider._();

/// Number of distinct products in the cart, for the header badge.

final class CartCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Number of distinct products in the cart, for the header badge.
  CartCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return cartCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$cartCountHash() => r'887dbdcc177613de8e02b8553c8a4a1f14d63413';

/// Server GST breakdown for the current cart (+ serviceability for
/// [pincode]). Recomputed whenever the cart changes.

@ProviderFor(cartQuote)
final cartQuoteProvider = CartQuoteFamily._();

/// Server GST breakdown for the current cart (+ serviceability for
/// [pincode]). Recomputed whenever the cart changes.

final class CartQuoteProvider
    extends
        $FunctionalProvider<
          AsyncValue<CartQuote>,
          CartQuote,
          FutureOr<CartQuote>
        >
    with $FutureModifier<CartQuote>, $FutureProvider<CartQuote> {
  /// Server GST breakdown for the current cart (+ serviceability for
  /// [pincode]). Recomputed whenever the cart changes.
  CartQuoteProvider._({
    required CartQuoteFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'cartQuoteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cartQuoteHash();

  @override
  String toString() {
    return r'cartQuoteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CartQuote> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CartQuote> create(Ref ref) {
    final argument = this.argument as String?;
    return cartQuote(ref, pincode: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CartQuoteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cartQuoteHash() => r'9d6d835dc2f14141b5c72d6e92aa19aa73596cde';

/// Server GST breakdown for the current cart (+ serviceability for
/// [pincode]). Recomputed whenever the cart changes.

final class CartQuoteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CartQuote>, String?> {
  CartQuoteFamily._()
    : super(
        retry: null,
        name: r'cartQuoteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Server GST breakdown for the current cart (+ serviceability for
  /// [pincode]). Recomputed whenever the cart changes.

  CartQuoteProvider call({String? pincode}) =>
      CartQuoteProvider._(argument: pincode, from: this);

  @override
  String toString() => r'cartQuoteProvider';
}
