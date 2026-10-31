import 'package:meta/meta.dart';

/// What a push is about. Parsed from the FCM `data.type` field. Backend
/// event names (`payment.success`, `wallet.low`, …) are accepted as aliases.
enum PushKind {
  // customer_app
  orderConfirmed,
  orderOutForDelivery,
  orderDelivered,
  subscription,
  walletLow,
  promo,
  // delivery_app
  routeAssigned,
  routeChanged,
  cutoffReady,
  unknown;

  static PushKind parse(String? type) {
    final t = (type ?? '').trim().toLowerCase();
    return switch (t) {
      'order.confirmed' || 'payment.success' => orderConfirmed,
      'order.out_for_delivery' ||
      'shipment.out_for_delivery' ||
      'shipment.in_transit' => orderOutForDelivery,
      'order.delivered' ||
      'shipment.delivered' ||
      'delivery.completed' => orderDelivered,
      'wallet.low' => walletLow,
      'promo' || 'marketing.promo' || 'marketing.winback' => promo,
      'route.assigned' => routeAssigned,
      'route.changed' => routeChanged,
      'cutoff.ready' || 'delivery.cutoff_ready' => cutoffReady,
      _ when t.startsWith('subscription.') || t == 'order.generated' =>
        subscription,
      _ => unknown,
    };
  }
}

/// A push message's routable content.
///
/// The FCM `data` map is untrusted input: only the known `type` values and
/// positive integer ids are read. Free-form links are deliberately NOT
/// supported, so a crafted push can never open an arbitrary route or URL.
///
/// Contract (all values are strings, as FCM requires):
/// `{"type": "order.confirmed", "order_id": "123"}`,
/// `{"type": "subscription.reminder", "subscription_id": "5"}`,
/// `{"type": "wallet.low"}`, `{"type": "promo", "product_id": "2"}`,
/// `{"type": "route.assigned"}`.
@immutable
class PushPayload {
  const PushPayload({
    required this.kind,
    this.orderId,
    this.subscriptionId,
    this.productId,
  });

  factory PushPayload.fromData(Map<String, Object?> data) => PushPayload(
    kind: PushKind.parse(data['type']?.toString()),
    orderId: _id(data['order_id']),
    subscriptionId: _id(data['subscription_id']),
    productId: _id(data['product_id']),
  );

  static int? _id(Object? raw) {
    final v = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    return v != null && v > 0 ? v : null;
  }

  final PushKind kind;
  final int? orderId;
  final int? subscriptionId;
  final int? productId;

  @override
  bool operator ==(Object other) =>
      other is PushPayload &&
      other.kind == kind &&
      other.orderId == orderId &&
      other.subscriptionId == subscriptionId &&
      other.productId == productId;

  @override
  int get hashCode => Object.hash(kind, orderId, subscriptionId, productId);

  @override
  String toString() => 'PushPayload(${kind.name}, order: $orderId)';
}

/// Maps a payload to an in-app location (null = just open the app).
typedef PushRouteResolver = String? Function(PushPayload payload);
