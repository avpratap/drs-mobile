// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliver_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverItem _$DeliverItemFromJson(Map<String, dynamic> json) => $checkedCreate(
  'DeliverItem',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['product_id', 'qty_delivered']);
    final val = DeliverItem(
      productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
      qtyDelivered: $checkedConvert('qty_delivered', (v) => v as num),
    );
    return val;
  },
  fieldKeyMap: const {
    'productId': 'product_id',
    'qtyDelivered': 'qty_delivered',
  },
);

Map<String, dynamic> _$DeliverItemToJson(DeliverItem instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'qty_delivered': instance.qtyDelivered,
    };
