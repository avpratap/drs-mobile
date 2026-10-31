import 'package:meta/meta.dart';

import '../utils/pii.dart';
import 'money.dart';

/// Rider-facing state of a stop.
///
/// Backend delivery-order statuses: `generated` (planned), `frozen` (locked
/// by the nightly cutoff run and loaded for today's route → shown as "out
/// for delivery"), `delivered`, `partially_delivered`, `failed`.
enum DeliveryStatus {
  pending,
  outForDelivery,
  delivered,
  partiallyDelivered,
  failed,
  unknown;

  static DeliveryStatus parse(String raw) => switch (raw.toLowerCase()) {
    'generated' || 'pending' || 'planned' => DeliveryStatus.pending,
    'frozen' ||
    'out_for_delivery' ||
    'dispatched' => DeliveryStatus.outForDelivery,
    'delivered' => DeliveryStatus.delivered,
    'partially_delivered' => DeliveryStatus.partiallyDelivered,
    'failed' => DeliveryStatus.failed,
    _ => DeliveryStatus.unknown,
  };

  /// Only open stops can be delivered / failed (backend rule).
  bool get isOpen => this == pending || this == outForDelivery;

  bool get isDone => this == delivered || this == partiallyDelivered;

  String get label => switch (this) {
    pending => 'Pending',
    outForDelivery => 'Out for delivery',
    delivered => 'Delivered',
    partiallyDelivered => 'Partly delivered',
    failed => 'Failed',
    unknown => 'Unknown',
  };
}

/// Why a stop could not be delivered (backend FailIn reasons).
enum FailReason {
  customerUnavailable('customer_unavailable', 'Customer unavailable'),
  addressWrong('address_wrong', 'Wrong address'),
  refused('refused', 'Refused'),
  other('other', 'Other');

  const FailReason(this.wire, this.label);

  final String wire;
  final String label;
}

@immutable
class DeliveryLine {
  const DeliveryLine({
    required this.productId,
    required this.qtyPlanned,
    this.qtyDelivered = 0,
    this.lineTotal = Money.zero,
  });

  final int productId;
  final double qtyPlanned;
  final double qtyDelivered;
  final Money lineTotal;
}

/// One stop on the rider's route (a backend delivery order + shop details).
/// Holds PII (contact name/phone, address): [toString] is redacted.
@immutable
class DeliveryStop {
  const DeliveryStop({
    required this.orderId,
    required this.sequence,
    required this.shopId,
    required this.status,
    required this.deliveryDate,
    this.shopName,
    this.address,
    this.pincode,
    this.lat,
    this.lng,
    this.contactName,
    this.contactPhone,
    this.failureReason,
    this.amountDue = Money.zero,
    this.total = Money.zero,
    this.lines = const [],
  });

  final int orderId;
  final int sequence;
  final int shopId;
  final DeliveryStatus status;
  final DateTime deliveryDate;
  final String? shopName;
  final String? address;
  final String? pincode;
  final double? lat;
  final double? lng;
  final String? contactName;
  final String? contactPhone;
  final String? failureReason;
  final Money amountDue;
  final Money total;
  final List<DeliveryLine> lines;

  bool get hasCoordinates => lat != null && lng != null;

  String get title =>
      (shopName?.trim().isNotEmpty ?? false) ? shopName! : 'Stop $sequence';

  String get addressLine => [
    address,
    pincode,
  ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' – ');

  String? get maskedPhone =>
      contactPhone == null ? null : Pii.maskPhone(contactPhone!);

  DeliveryStop withStatus(DeliveryStatus s) => DeliveryStop(
    orderId: orderId,
    sequence: sequence,
    shopId: shopId,
    status: s,
    deliveryDate: deliveryDate,
    shopName: shopName,
    address: address,
    pincode: pincode,
    lat: lat,
    lng: lng,
    contactName: contactName,
    contactPhone: contactPhone,
    failureReason: failureReason,
    amountDue: amountDue,
    total: total,
    lines: lines,
  );

  @override
  String toString() =>
      'DeliveryStop(order: $orderId, seq: $sequence, ${status.name})';
}

/// Stops of one shop (a rider may serve several shops in a day).
@immutable
class ShopGroup {
  const ShopGroup({
    required this.shopId,
    required this.name,
    required this.stops,
  });

  final int shopId;
  final String name;
  final List<DeliveryStop> stops;

  int get doneCount => stops.where((s) => !s.status.isOpen).length;

  /// Groups [stops] by shop, keeping route order (first stop of each shop).
  static List<ShopGroup> group(List<DeliveryStop> stops) {
    final order = <int>[];
    final by = <int, List<DeliveryStop>>{};
    for (final s in [
      ...stops,
    ]..sort((a, b) => a.sequence.compareTo(b.sequence))) {
      by
          .putIfAbsent(s.shopId, () {
            order.add(s.shopId);
            return [];
          })
          .add(s);
    }
    return [
      for (final id in order)
        ShopGroup(shopId: id, name: by[id]!.first.title, stops: by[id]!),
    ];
  }
}

/// Day totals for the header.
@immutable
class RouteSummary {
  const RouteSummary({
    required this.total,
    required this.done,
    required this.failed,
  });

  factory RouteSummary.of(List<DeliveryStop> stops) => RouteSummary(
    total: stops.length,
    done: stops.where((s) => s.status.isDone).length,
    failed: stops.where((s) => s.status == DeliveryStatus.failed).length,
  );

  final int total;
  final int done;
  final int failed;

  int get remaining => total - done - failed;
}
