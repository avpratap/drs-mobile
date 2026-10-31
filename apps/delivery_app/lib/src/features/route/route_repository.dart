import 'dart:convert';

import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';

import '../../data/delivery_database.dart';
import '../../data/mappers.dart';

/// A read that may have come from the device cache.
class Cached<T> {
  const Cached(
    this.value, {
    required this.fromCache,
    this.fetchedAt,
    this.error,
  });

  final T value;
  final bool fromCache;
  final DateTime? fetchedAt;
  final DrsApiError? error;
}

/// Product display info (delivery lines carry only product ids).
class ProductInfo {
  const ProductInfo(this.name, this.uom);

  final String name;
  final String uom;
}

String dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Today's route, network-first with a Drift fallback.
class RouteRepository {
  RouteRepository({
    required this._api,
    required this._db,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DrsApi _api;
  final DeliveryDatabase _db;
  final DateTime Function() _clock;

  static String routeKey(DateTime day) => 'route:${dateKey(day)}';
  static const productsKey = 'products';

  List<DeliveryStop> _decodeRoute(String json) => [
    for (final s in (jsonDecode(json) as List).cast<Map<String, dynamic>>())
      if (RouteStopOut.fromJson(s) case final stop)
        stop.order.toStop(stop.sequence),
  ];

  Future<Cached<List<DeliveryStop>>?> cachedRoute(DateTime day) async {
    final json = await _db.readJson(routeKey(day));
    return json == null ? null : Cached(_decodeRoute(json), fromCache: true);
  }

  /// `delivery_route` for [day] (the backend scopes it to the rider's shops).
  Future<Cached<List<DeliveryStop>>> fetchRoute(DateTime day) async {
    try {
      final stops =
          (await _api.getDeliveryApi().deliveryRoute(date: day)).data ??
          const [];
      final json = jsonEncode([for (final s in stops) s.toJson()]);
      final now = _clock();
      await _db.writeJson(routeKey(day), json, now);
      return Cached(_decodeRoute(json), fromCache: false, fetchedAt: now);
    } on Object catch (e) {
      final error = DrsApiError.from(e);
      final cached = await _db.readJson(routeKey(day));
      if (cached == null) throw error;
      return Cached(_decodeRoute(cached), fromCache: true, error: error);
    }
  }

  /// Product names for line items (public catalogue; cached).
  Future<Map<int, ProductInfo>> products() async {
    Map<int, ProductInfo> decode(String json) => {
      for (final p in (jsonDecode(json) as List).cast<Map<String, dynamic>>())
        p['id'] as int: ProductInfo(
          p['name'] as String,
          (p['uom'] as String?) ?? 'piece',
        ),
    };
    try {
      final list =
          (await _api.getProductsApi().listProducts(limit: 200)).data ??
          const [];
      final json = jsonEncode([
        for (final p in list) {'id': p.id, 'name': p.name, 'uom': p.uom},
      ]);
      await _db.writeJson(productsKey, json, _clock());
      return decode(json);
    } on Object {
      final cached = await _db.readJson(productsKey);
      return cached == null ? const {} : decode(cached);
    }
  }
}
