// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todays_deliveries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `list_delivery_orders` for today, scoped server-side to the rider.

@ProviderFor(todaysDeliveries)
final todaysDeliveriesProvider = TodaysDeliveriesProvider._();

/// `list_delivery_orders` for today, scoped server-side to the rider.

final class TodaysDeliveriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DeliveryOrderOut>>,
          List<DeliveryOrderOut>,
          FutureOr<List<DeliveryOrderOut>>
        >
    with
        $FutureModifier<List<DeliveryOrderOut>>,
        $FutureProvider<List<DeliveryOrderOut>> {
  /// `list_delivery_orders` for today, scoped server-side to the rider.
  TodaysDeliveriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysDeliveriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysDeliveriesHash();

  @$internal
  @override
  $FutureProviderElement<List<DeliveryOrderOut>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DeliveryOrderOut>> create(Ref ref) {
    return todaysDeliveries(ref);
  }
}

String _$todaysDeliveriesHash() => r'ab15b09e5d75be0e17150492ce5ba19e7a470b40';
