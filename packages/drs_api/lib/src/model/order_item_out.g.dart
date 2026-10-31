// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemOut _$OrderItemOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OrderItemOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['product_id', 'qty', 'unit_price', 'line_total'],
        );
        final val = OrderItemOut(
          productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
          qty: $checkedConvert('qty', (v) => v as num),
          unitPrice: $checkedConvert('unit_price', (v) => v as num),
          lineTotal: $checkedConvert('line_total', (v) => v as num),
          gstRate: $checkedConvert('gst_rate', (v) => v as num? ?? 0),
          gstAmount: $checkedConvert('gst_amount', (v) => v as num? ?? 0),
          priceInclTax: $checkedConvert(
            'price_incl_tax',
            (v) => v as num? ?? 0,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'productId': 'product_id',
        'unitPrice': 'unit_price',
        'lineTotal': 'line_total',
        'gstRate': 'gst_rate',
        'gstAmount': 'gst_amount',
        'priceInclTax': 'price_incl_tax',
      },
    );

Map<String, dynamic> _$OrderItemOutToJson(OrderItemOut instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'qty': instance.qty,
      'unit_price': instance.unitPrice,
      'line_total': instance.lineTotal,
      'gst_rate': ?instance.gstRate,
      'gst_amount': ?instance.gstAmount,
      'price_incl_tax': ?instance.priceInclTax,
    };
