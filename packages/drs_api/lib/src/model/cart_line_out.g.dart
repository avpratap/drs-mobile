// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_line_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartLineOut _$CartLineOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'CartLineOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'product_id',
        'qty',
        'unit_price',
        'line_total',
      ],
    );
    final val = CartLineOut(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
      qty: $checkedConvert('qty', (v) => v as num),
      unitPrice: $checkedConvert('unit_price', (v) => v as num),
      lineTotal: $checkedConvert('line_total', (v) => v as num),
    );
    return val;
  },
  fieldKeyMap: const {
    'productId': 'product_id',
    'unitPrice': 'unit_price',
    'lineTotal': 'line_total',
  },
);

Map<String, dynamic> _$CartLineOutToJson(CartLineOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'qty': instance.qty,
      'unit_price': instance.unitPrice,
      'line_total': instance.lineTotal,
    };
