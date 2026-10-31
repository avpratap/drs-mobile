import 'dart:async';

import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers.dart';
import '../../data/delivery_database.dart';
import 'route_repository.dart';

part 'route_providers.g.dart';

/// Today's date in India (IST, UTC+5:30) — delivery days are IST days, and
/// the backend defaults to *tomorrow* if no date is passed.
DateTime todayIst([DateTime? nowUtc]) {
  final ist = (nowUtc ?? DateTime.now().toUtc()).add(
    const Duration(hours: 5, minutes: 30),
  );
  return DateTime.utc(ist.year, ist.month, ist.day);
}

/// The delivery day shown (overridable in tests).
@Riverpod(keepAlive: true)
DateTime routeDay(Ref ref) => todayIst();

@Riverpod(keepAlive: true)
RouteRepository routeRepository(Ref ref) => RouteRepository(
  api: ref.watch(drsApiProvider),
  db: ref.watch(deliveryDatabaseProvider),
);

/// Cache first (instant, offline), then the network.
@Riverpod(keepAlive: true)
Stream<Cached<List<DeliveryStop>>> route(Ref ref) async* {
  final repo = ref.watch(routeRepositoryProvider);
  final day = ref.watch(routeDayProvider);
  final cached = await repo.cachedRoute(day);
  if (cached != null) yield cached;
  yield await repo.fetchRoute(day);
}

@Riverpod(keepAlive: true)
Future<Map<int, ProductInfo>> products(Ref ref) =>
    ref.watch(routeRepositoryProvider).products();

@Riverpod(keepAlive: true)
Stream<List<QueuedAction>> pendingActions(Ref ref) =>
    ref.watch(deliveryDatabaseProvider).watchPending();

/// A stop as the rider should see it: server state overlaid with any action
/// taken on this device that hasn't synced yet.
class StopView {
  const StopView(this.stop, this.pending);

  final DeliveryStop stop;
  final QueuedAction? pending;

  bool get waitingToSync => pending?.state == 'queued';
  bool get needsAttention => pending?.state == 'failed';

  DeliveryStatus get status {
    final p = pending;
    if (p == null) return stop.status;
    return p.kind == 'fail' ? DeliveryStatus.failed : DeliveryStatus.delivered;
  }

  /// Open on the device (no local action yet and open on the server).
  bool get canAct => pending == null && stop.status.isOpen;
}

class RouteView {
  const RouteView({required this.stops, required this.fromCache, this.error});

  final List<StopView> stops;
  final bool fromCache;
  final DrsApiError? error;

  List<DeliveryStop> get effectiveStops => [
    for (final v in stops) v.stop.withStatus(v.status),
  ];

  StopView? byOrder(int orderId) =>
      stops.where((v) => v.stop.orderId == orderId).firstOrNull;
}

@riverpod
Future<RouteView> routeView(Ref ref) async {
  final route = await ref.watch(routeProvider.future);
  final pending = await ref.watch(pendingActionsProvider.future);
  final byOrder = {for (final p in pending) p.orderId: p};
  return RouteView(
    stops: [for (final s in route.value) StopView(s, byOrder[s.orderId])],
    fromCache: route.fromCache,
    error: route.error,
  );
}
