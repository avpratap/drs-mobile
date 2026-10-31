// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// id → product from the (cached) catalogue, to name cart / order /
/// subscription lines that only carry a product id.

@ProviderFor(productIndex)
final productIndexProvider = ProductIndexProvider._();

/// id → product from the (cached) catalogue, to name cart / order /
/// subscription lines that only carry a product id.

final class ProductIndexProvider
    extends
        $FunctionalProvider<
          Map<int, Product>,
          Map<int, Product>,
          Map<int, Product>
        >
    with $Provider<Map<int, Product>> {
  /// id → product from the (cached) catalogue, to name cart / order /
  /// subscription lines that only carry a product id.
  ProductIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productIndexHash();

  @$internal
  @override
  $ProviderElement<Map<int, Product>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<int, Product> create(Ref ref) {
    return productIndex(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, Product>>(value),
    );
  }
}

String _$productIndexHash() => r'23c8142c8aa7caff7e80eff97357658c1839b78a';

/// Product page with pack sizes. Offline, falls back to the cached catalogue
/// entry with its default pack (adding to cart still needs the network).

@ProviderFor(productDetail)
final productDetailProvider = ProductDetailFamily._();

/// Product page with pack sizes. Offline, falls back to the cached catalogue
/// entry with its default pack (adding to cart still needs the network).

final class ProductDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductDetail>,
          ProductDetail,
          FutureOr<ProductDetail>
        >
    with $FutureModifier<ProductDetail>, $FutureProvider<ProductDetail> {
  /// Product page with pack sizes. Offline, falls back to the cached catalogue
  /// entry with its default pack (adding to cart still needs the network).
  ProductDetailProvider._({
    required ProductDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductDetail> create(Ref ref) {
    final argument = this.argument as int;
    return productDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailHash() => r'666da2400f334c16d269ab6ed868892db98bcfe4';

/// Product page with pack sizes. Offline, falls back to the cached catalogue
/// entry with its default pack (adding to cart still needs the network).

final class ProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductDetail>, int> {
  ProductDetailFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Product page with pack sizes. Offline, falls back to the cached catalogue
  /// entry with its default pack (adding to cart still needs the network).

  ProductDetailProvider call(int productId) =>
      ProductDetailProvider._(argument: productId, from: this);

  @override
  String toString() => r'productDetailProvider';
}
