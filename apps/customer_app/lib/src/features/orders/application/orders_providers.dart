import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../../data/api_guard.dart';
import '../data/orders_repository.dart';

part 'orders_providers.g.dart';

@Riverpod(keepAlive: true)
OrdersRepository ordersRepository(Ref ref) => OrdersRepository(
  api: ref.watch(drsApiProvider).getOrdersApi(),
  db: ref.watch(appDatabaseProvider),
);

@riverpod
Future<Cached<List<Order>>> orders(Ref ref) =>
    ref.watch(ordersRepositoryProvider).list();

@riverpod
Future<Order> orderDetail(Ref ref, int orderId) =>
    ref.watch(ordersRepositoryProvider).get(orderId);

@riverpod
Future<OrderTracking> orderTracking(Ref ref, int orderId) =>
    ref.watch(ordersRepositoryProvider).track(orderId);
