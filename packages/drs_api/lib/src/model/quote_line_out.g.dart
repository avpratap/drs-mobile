// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_line_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteLineOut _$QuoteLineOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'QuoteLineOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'product_id',
            'qty',
            'unit_price',
            'line_total',
            'gst_rate',
            'gst_amount',
          ],
        );
        final val = QuoteLineOut(
          productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
          qty: $checkedConvert('qty', (v) => v as num),
          unitPrice: $checkedConvert('unit_price', (v) => v as num),
          lineTotal: $checkedConvert('line_total', (v) => v as num),
          gstRate: $checkedConvert('gst_rate', (v) => v as num),
          gstAmount: $checkedConvert('gst_amount', (v) => v as num),
        );
        return val;
      },
      fieldKeyMap: const {
        'productId': 'product_id',
        'unitPrice': 'unit_price',
        'lineTotal': 'line_total',
        'gstRate': 'gst_rate',
        'gstAmount': 'gst_amount',
      },
    );

Map<String, dynamic> _$QuoteLineOutToJson(QuoteLineOut instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'qty': instance.qty,
      'unit_price': instance.unitPrice,
      'line_total': instance.lineTotal,
      'gst_rate': instance.gstRate,
      'gst_amount': instance.gstAmount,
    };
