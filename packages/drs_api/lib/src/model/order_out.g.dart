// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderOut _$OrderOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'OrderOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'order_no',
        'shop_id',
        'order_type',
        'status',
        'subtotal',
        'total',
        'payment_status',
      ],
    );
    final val = OrderOut(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      orderNo: $checkedConvert('order_no', (v) => v as String),
      shopId: $checkedConvert('shop_id', (v) => (v as num).toInt()),
      orderType: $checkedConvert('order_type', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String),
      subtotal: $checkedConvert('subtotal', (v) => v as num),
      total: $checkedConvert('total', (v) => v as num),
      paymentStatus: $checkedConvert('payment_status', (v) => v as String),
      discount: $checkedConvert('discount', (v) => v as num? ?? 0),
      couponCode: $checkedConvert('coupon_code', (v) => v as String?),
      taxTotal: $checkedConvert('tax_total', (v) => v as num? ?? 0),
      totalInclTax: $checkedConvert('total_incl_tax', (v) => v as num? ?? 0),
      items: $checkedConvert(
        'items',
        (v) => (v as List<dynamic>?)
            ?.map((e) => OrderItemOut.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'orderNo': 'order_no',
    'shopId': 'shop_id',
    'orderType': 'order_type',
    'paymentStatus': 'payment_status',
    'couponCode': 'coupon_code',
    'taxTotal': 'tax_total',
    'totalInclTax': 'total_incl_tax',
  },
);

Map<String, dynamic> _$OrderOutToJson(OrderOut instance) => <String, dynamic>{
  'id': instance.id,
  'order_no': instance.orderNo,
  'shop_id': instance.shopId,
  'order_type': instance.orderType,
  'status': instance.status,
  'subtotal': instance.subtotal,
  'total': instance.total,
  'payment_status': instance.paymentStatus,
  'discount': ?instance.discount,
  'coupon_code': ?instance.couponCode,
  'tax_total': ?instance.taxTotal,
  'total_incl_tax': ?instance.totalInclTax,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
};
