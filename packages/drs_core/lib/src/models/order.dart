import 'package:meta/meta.dart';

import 'money.dart';

enum OrderStatus {
  pending,
  confirmed,
  packed,
  outForDelivery,
  delivered,
  cancelled,
  failed,
  unknown;

  static OrderStatus parse(String raw) => switch (raw.toLowerCase()) {
    'pending' || 'placed' || 'new' => OrderStatus.pending,
    'confirmed' || 'accepted' => OrderStatus.confirmed,
    'packed' || 'ready' => OrderStatus.packed,
    'out_for_delivery' || 'dispatched' || 'shipped' => OrderStatus.outForDelivery,
    'delivered' || 'completed' => OrderStatus.delivered,
    'cancelled' || 'canceled' => OrderStatus.cancelled,
    'failed' => OrderStatus.failed,
    _ => OrderStatus.unknown,
  };

  bool get isTerminal =>
      this == delivered || this == cancelled || this == failed;
}

@immutable
class OrderLine {
  const OrderLine({
    required this.productId,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int productId;
  final double qty;
  final Money unitPrice;
  final Money lineTotal;
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.subtotal,
    required this.total,
    required this.paymentStatus,
    this.discount = Money.zero,
    this.taxTotal = Money.zero,
    this.lines = const [],
  });

  final int id;
  final String orderNo;
  final OrderStatus status;
  final Money subtotal;
  final Money discount;

  /// GST portion *inside* [total] (prices are GST-inclusive).
  final Money taxTotal;
  final Money total;
  final String paymentStatus;
  final List<OrderLine> lines;
}
