// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteOut _$QuoteOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'QuoteOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'subtotal',
        'discount',
        'tax_total',
        'total',
        'total_incl_tax',
      ],
    );
    final val = QuoteOut(
      subtotal: $checkedConvert('subtotal', (v) => v as num),
      discount: $checkedConvert('discount', (v) => v as num),
      taxTotal: $checkedConvert('tax_total', (v) => v as num),
      total: $checkedConvert('total', (v) => v as num),
      totalInclTax: $checkedConvert('total_incl_tax', (v) => v as num),
      items: $checkedConvert(
        'items',
        (v) => (v as List<dynamic>?)
            ?.map((e) => QuoteLineOut.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      serviceable: $checkedConvert('serviceable', (v) => v as bool?),
      etdDays: $checkedConvert('etd_days', (v) => (v as num?)?.toInt()),
      shippingRate: $checkedConvert('shipping_rate', (v) => v as num?),
    );
    return val;
  },
  fieldKeyMap: const {
    'taxTotal': 'tax_total',
    'totalInclTax': 'total_incl_tax',
    'etdDays': 'etd_days',
    'shippingRate': 'shipping_rate',
  },
);

Map<String, dynamic> _$QuoteOutToJson(QuoteOut instance) => <String, dynamic>{
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'tax_total': instance.taxTotal,
  'total': instance.total,
  'total_incl_tax': instance.totalInclTax,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
  'serviceable': ?instance.serviceable,
  'etd_days': ?instance.etdDays,
  'shipping_rate': ?instance.shippingRate,
};
