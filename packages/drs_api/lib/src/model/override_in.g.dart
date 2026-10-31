// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'override_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverrideIn _$OverrideInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'OverrideIn',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['product_id', 'for_date', 'override_qty'],
    );
    final val = OverrideIn(
      productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
      forDate: $checkedConvert('for_date', (v) => DateTime.parse(v as String)),
      overrideQty: $checkedConvert('override_qty', (v) => v as num),
      note: $checkedConvert('note', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'productId': 'product_id',
    'forDate': 'for_date',
    'overrideQty': 'override_qty',
  },
);

Map<String, dynamic> _$OverrideInToJson(OverrideIn instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'for_date': instance.forDate.toIso8601String(),
      'override_qty': instance.overrideQty,
      'note': ?instance.note,
    };
