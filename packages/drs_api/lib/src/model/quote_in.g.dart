// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteIn _$QuoteInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'QuoteIn',
  json,
  ($checkedConvert) {
    final val = QuoteIn(
      couponCode: $checkedConvert('coupon_code', (v) => v as String?),
      pincode: $checkedConvert('pincode', (v) => v as String?),
      weightKg: $checkedConvert('weight_kg', (v) => v as num? ?? 0.5),
      cod: $checkedConvert('cod', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {'couponCode': 'coupon_code', 'weightKg': 'weight_kg'},
);

Map<String, dynamic> _$QuoteInToJson(QuoteIn instance) => <String, dynamic>{
  'coupon_code': ?instance.couponCode,
  'pincode': ?instance.pincode,
  'weight_kg': ?instance.weightKg,
  'cod': ?instance.cod,
};
