// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_order_item_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryOrderItemOut _$DeliveryOrderItemOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'DeliveryOrderItemOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'product_id',
        'qty_planned',
        'qty_delivered',
        'unit_price',
        'line_total',
        'status',
      ],
    );
    final val = DeliveryOrderItemOut(
      productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
      qtyPlanned: $checkedConvert('qty_planned', (v) => v as num),
      qtyDelivered: $checkedConvert('qty_delivered', (v) => v as num),
      unitPrice: $checkedConvert('unit_price', (v) => v as num),
      lineTotal: $checkedConvert('line_total', (v) => v as num),
      status: $checkedConvert('status', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'productId': 'product_id',
    'qtyPlanned': 'qty_planned',
    'qtyDelivered': 'qty_delivered',
    'unitPrice': 'unit_price',
    'lineTotal': 'line_total',
  },
);

Map<String, dynamic> _$DeliveryOrderItemOutToJson(
  DeliveryOrderItemOut instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'qty_planned': instance.qtyPlanned,
  'qty_delivered': instance.qtyDelivered,
  'unit_price': instance.unitPrice,
  'line_total': instance.lineTotal,
  'status': instance.status,
};
