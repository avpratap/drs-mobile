import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/local/app_database.dart';
import '../../../data/mappers.dart';

class OrdersRepository {
  OrdersRepository({required this._api, required this._db});

  final OrdersApi _api;
  final AppDatabase _db;

  static const cacheKey = 'orders';

  /// Newest first; served from Drift when offline.
  Future<Cached<List<Order>>> list() => readThrough(
    db: _db,
    key: cacheKey,
    fetch: () async => [
      for (final o
          in (await _api.listOrders(limit: 50)).data ?? const <OrderOut>[])
        o.toJson(),
    ],
    decode: (json) => [
      for (final o in json)
        OrderOut.fromJson(o! as Map<String, dynamic>).toDomain(),
    ],
  );

  Future<Order> get(int id) =>
      guard(() async => (await _api.getOrder(orderId: id)).data!.toDomain());

  Future<OrderTracking> track(int id) =>
      guard(() async => (await _api.trackOrder(orderId: id)).data!.toDomain());

  Future<Order> cancel(int id) =>
      guard(() async => (await _api.cancelOrder(orderId: id)).data!.toDomain());
}
