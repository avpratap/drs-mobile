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
    // Backend creates orders as `created` and may move them to `pending`.
    'created' || 'pending' || 'placed' || 'new' => OrderStatus.pending,
    'confirmed' || 'accepted' => OrderStatus.confirmed,
    'packed' || 'ready' => OrderStatus.packed,
    'out_for_delivery' ||
    'dispatched' ||
    'shipped' ||
    'in_transit' => OrderStatus.outForDelivery,
    'delivered' || 'completed' => OrderStatus.delivered,
    'cancelled' || 'canceled' => OrderStatus.cancelled,
    'failed' => OrderStatus.failed,
    _ => OrderStatus.unknown,
  };

  bool get isTerminal =>
      this == delivered || this == cancelled || this == failed;

  String get label => switch (this) {
    pending => 'Placed',
    confirmed => 'Confirmed',
    packed => 'Packed',
    outForDelivery => 'Out for delivery',
    delivered => 'Delivered',
    cancelled => 'Cancelled',
    failed => 'Failed',
    unknown => 'Processing',
  };
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  unknown;

  static PaymentStatus parse(String raw) => switch (raw.toLowerCase()) {
    'pending' || 'initiated' || 'created' => PaymentStatus.pending,
    'paid' || 'success' || 'captured' => PaymentStatus.paid,
    'failed' => PaymentStatus.failed,
    'refunded' || 'partially_refunded' => PaymentStatus.refunded,
    _ => PaymentStatus.unknown,
  };

  String get label => switch (this) {
    pending => 'Payment pending',
    paid => 'Paid',
    failed => 'Payment failed',
    refunded => 'Refunded',
    unknown => 'Payment status unknown',
  };
}

@immutable
class OrderLine {
  const OrderLine({
    required this.productId,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    this.gstRate = 0,
    this.gstAmount = Money.zero,
  });

  final int productId;
  final double qty;
  final Money unitPrice;
  final Money lineTotal;
  final double gstRate;

  /// GST portion *inside* [lineTotal] (prices are GST-inclusive).
  final Money gstAmount;
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
    this.couponCode,
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
  final PaymentStatus paymentStatus;
  final String? couponCode;
  final List<OrderLine> lines;

  /// Mirrors the backend's cancel rule: unpaid and not yet dispatched.
  bool get canCancel =>
      status == OrderStatus.pending && paymentStatus != PaymentStatus.paid;

  /// An unpaid, still-open order can be paid (create_payment resumes it).
  bool get canPay =>
      status == OrderStatus.pending && paymentStatus == PaymentStatus.pending;
}

@immutable
class TrackingEvent {
  const TrackingEvent({
    required this.status,
    this.location,
    this.note,
    this.time,
  });

  final String status;
  final String? location;
  final String? note;
  final DateTime? time;
}

@immutable
class Shipment {
  const Shipment({
    required this.shipmentNo,
    required this.status,
    this.courier,
    this.awb,
    this.trackingUrl,
    this.events = const [],
  });

  final String shipmentNo;
  final String status;
  final String? courier;
  final String? awb;
  final String? trackingUrl;

  /// Newest first.
  final List<TrackingEvent> events;
}

@immutable
class OrderTracking {
  const OrderTracking({
    required this.orderId,
    required this.orderNo,
    required this.status,
    required this.paymentStatus,
    this.shipments = const [],
  });

  final int orderId;
  final String orderNo;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final List<Shipment> shipments;

  /// Progress steps for a timeline, and the index reached (-1 = cancelled).
  static const steps = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.packed,
    OrderStatus.outForDelivery,
    OrderStatus.delivered,
  ];

  int get stepIndex {
    if (status == OrderStatus.cancelled || status == OrderStatus.failed) {
      return -1;
    }
    final i = steps.indexOf(status);
    if (i >= 0) return i;
    // A courier shipment means it has at least left the dairy.
    return shipments.isNotEmpty ? 3 : 0;
  }
}
