// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanLine _$PlanLineFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlanLine', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['product_id', 'qty']);
      final val = PlanLine(
        productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
        qty: $checkedConvert('qty', (v) => v as num),
      );
      return val;
    }, fieldKeyMap: const {'productId': 'product_id'});

Map<String, dynamic> _$PlanLineToJson(PlanLine instance) => <String, dynamic>{
  'product_id': instance.productId,
  'qty': instance.qty,
};
