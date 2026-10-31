// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_tracking_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTrackingOut _$OrderTrackingOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'OrderTrackingOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['order_id', 'order_no', 'status', 'payment_status'],
    );
    final val = OrderTrackingOut(
      orderId: $checkedConvert('order_id', (v) => (v as num).toInt()),
      orderNo: $checkedConvert('order_no', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String),
      paymentStatus: $checkedConvert('payment_status', (v) => v as String),
      shipments: $checkedConvert(
        'shipments',
        (v) => (v as List<dynamic>?)
            ?.map((e) => ShipmentTrackOut.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'orderId': 'order_id',
    'orderNo': 'order_no',
    'paymentStatus': 'payment_status',
  },
);

Map<String, dynamic> _$OrderTrackingOutToJson(OrderTrackingOut instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_no': instance.orderNo,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'shipments': ?instance.shipments?.map((e) => e.toJson()).toList(),
    };
