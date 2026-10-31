// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogue_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'aa210fe451b458f844e17358f6363a509891cf3c';

/// Stale-while-revalidate catalogue: emits the Drift cache immediately (if
/// any), then the network result (or the cache again, flagged offline).

@ProviderFor(catalogue)
final catalogueProvider = CatalogueProvider._();

/// Stale-while-revalidate catalogue: emits the Drift cache immediately (if
/// any), then the network result (or the cache again, flagged offline).

final class CatalogueProvider
    extends
        $FunctionalProvider<
          AsyncValue<CatalogueSnapshot>,
          CatalogueSnapshot,
          Stream<CatalogueSnapshot>
        >
    with
        $FutureModifier<CatalogueSnapshot>,
        $StreamProvider<CatalogueSnapshot> {
  /// Stale-while-revalidate catalogue: emits the Drift cache immediately (if
  /// any), then the network result (or the cache again, flagged offline).
  CatalogueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogueHash();

  @$internal
  @override
  $StreamProviderElement<CatalogueSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CatalogueSnapshot> create(Ref ref) {
    return catalogue(ref);
  }
}

String _$catalogueHash() => r'812171f9a9eba5d97d79b019676356af4ce0841c';
