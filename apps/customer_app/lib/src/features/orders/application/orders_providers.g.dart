// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ordersRepository)
final ordersRepositoryProvider = OrdersRepositoryProvider._();

final class OrdersRepositoryProvider
    extends
        $FunctionalProvider<
          OrdersRepository,
          OrdersRepository,
          OrdersRepository
        >
    with $Provider<OrdersRepository> {
  OrdersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrdersRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrdersRepository create(Ref ref) {
    return ordersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrdersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrdersRepository>(value),
    );
  }
}

String _$ordersRepositoryHash() => r'04cd05e044ecaa9dd9879efbeb82b2cdc4129f52';

@ProviderFor(orders)
final ordersProvider = OrdersProvider._();

final class OrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<List<Order>>>,
          Cached<List<Order>>,
          FutureOr<Cached<List<Order>>>
        >
    with
        $FutureModifier<Cached<List<Order>>>,
        $FutureProvider<Cached<List<Order>>> {
  OrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersHash();

  @$internal
  @override
  $FutureProviderElement<Cached<List<Order>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<List<Order>>> create(Ref ref) {
    return orders(ref);
  }
}

String _$ordersHash() => r'dabfce724c8fb5b2e0e61a8ac27a67cc1c7a165a';

@ProviderFor(orderDetail)
final orderDetailProvider = OrderDetailFamily._();

final class OrderDetailProvider
    extends $FunctionalProvider<AsyncValue<Order>, Order, FutureOr<Order>>
    with $FutureModifier<Order>, $FutureProvider<Order> {
  OrderDetailProvider._({
    required OrderDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'orderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderDetailHash();

  @override
  String toString() {
    return r'orderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Order> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Order> create(Ref ref) {
    final argument = this.argument as int;
    return orderDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailHash() => r'ecda54c3cae7e36051521a5cb48550c1c8477455';

final class OrderDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Order>, int> {
  OrderDetailFamily._()
    : super(
        retry: null,
        name: r'orderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderDetailProvider call(int orderId) =>
      OrderDetailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderDetailProvider';
}

@ProviderFor(orderTracking)
final orderTrackingProvider = OrderTrackingFamily._();

final class OrderTrackingProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderTracking>,
          OrderTracking,
          FutureOr<OrderTracking>
        >
    with $FutureModifier<OrderTracking>, $FutureProvider<OrderTracking> {
  OrderTrackingProvider._({
    required OrderTrackingFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'orderTrackingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderTrackingHash();

  @override
  String toString() {
    return r'orderTrackingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderTracking> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderTracking> create(Ref ref) {
    final argument = this.argument as int;
    return orderTracking(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderTrackingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderTrackingHash() => r'33edd25afc03bb818ce640f5e758e5e5be033ef4';

final class OrderTrackingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderTracking>, int> {
  OrderTrackingFamily._()
    : super(
        retry: null,
        name: r'orderTrackingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderTrackingProvider call(int orderId) =>
      OrderTrackingProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderTrackingProvider';
}
