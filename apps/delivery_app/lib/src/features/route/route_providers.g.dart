// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The delivery day shown (overridable in tests).

@ProviderFor(routeDay)
final routeDayProvider = RouteDayProvider._();

/// The delivery day shown (overridable in tests).

final class RouteDayProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The delivery day shown (overridable in tests).
  RouteDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeDayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeDayHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return routeDay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$routeDayHash() => r'3ca098b12a10a931346f5e3d82b32b23f533b140';

@ProviderFor(routeRepository)
final routeRepositoryProvider = RouteRepositoryProvider._();

final class RouteRepositoryProvider
    extends
        $FunctionalProvider<RouteRepository, RouteRepository, RouteRepository>
    with $Provider<RouteRepository> {
  RouteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeRepositoryHash();

  @$internal
  @override
  $ProviderElement<RouteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RouteRepository create(Ref ref) {
    return routeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouteRepository>(value),
    );
  }
}

String _$routeRepositoryHash() => r'b247e968f034de219550479c564a2d877e6e3a56';

/// Cache first (instant, offline), then the network.

@ProviderFor(route)
final routeProvider = RouteProvider._();

/// Cache first (instant, offline), then the network.

final class RouteProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<List<DeliveryStop>>>,
          Cached<List<DeliveryStop>>,
          Stream<Cached<List<DeliveryStop>>>
        >
    with
        $FutureModifier<Cached<List<DeliveryStop>>>,
        $StreamProvider<Cached<List<DeliveryStop>>> {
  /// Cache first (instant, offline), then the network.
  RouteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeHash();

  @$internal
  @override
  $StreamProviderElement<Cached<List<DeliveryStop>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Cached<List<DeliveryStop>>> create(Ref ref) {
    return route(ref);
  }
}

String _$routeHash() => r'e5e730b6de33bbbe37ea55f07812243b15bf1d1a';

@ProviderFor(products)
final productsProvider = ProductsProvider._();

final class ProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, ProductInfo>>,
          Map<int, ProductInfo>,
          FutureOr<Map<int, ProductInfo>>
        >
    with
        $FutureModifier<Map<int, ProductInfo>>,
        $FutureProvider<Map<int, ProductInfo>> {
  ProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, ProductInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, ProductInfo>> create(Ref ref) {
    return products(ref);
  }
}

String _$productsHash() => r'754b1eaa54912224139f1b5cd1b3e131ed653ff8';

@ProviderFor(pendingActions)
final pendingActionsProvider = PendingActionsProvider._();

final class PendingActionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QueuedAction>>,
          List<QueuedAction>,
          Stream<List<QueuedAction>>
        >
    with
        $FutureModifier<List<QueuedAction>>,
        $StreamProvider<List<QueuedAction>> {
  PendingActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingActionsHash();

  @$internal
  @override
  $StreamProviderElement<List<QueuedAction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<QueuedAction>> create(Ref ref) {
    return pendingActions(ref);
  }
}

String _$pendingActionsHash() => r'c06d16ac1986412c205d7ef5a4e29928e9e1fe4e';

@ProviderFor(routeView)
final routeViewProvider = RouteViewProvider._();

final class RouteViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<RouteView>,
          RouteView,
          FutureOr<RouteView>
        >
    with $FutureModifier<RouteView>, $FutureProvider<RouteView> {
  RouteViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeViewHash();

  @$internal
  @override
  $FutureProviderElement<RouteView> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RouteView> create(Ref ref) {
    return routeView(ref);
  }
}

String _$routeViewHash() => r'df9597eab7f8abb19e8985cb4634335ce72a2266';
