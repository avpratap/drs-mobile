// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'override_saved_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverrideSavedOut _$OverrideSavedOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OverrideSavedOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['detail', 'product_id', 'for_date', 'qty'],
      );
      final val = OverrideSavedOut(
        detail: $checkedConvert('detail', (v) => v as String),
        productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
        forDate: $checkedConvert('for_date', (v) => v as String),
        qty: $checkedConvert('qty', (v) => v as num),
      );
      return val;
    }, fieldKeyMap: const {'productId': 'product_id', 'forDate': 'for_date'});

Map<String, dynamic> _$OverrideSavedOutToJson(OverrideSavedOut instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'product_id': instance.productId,
      'for_date': instance.forDate,
      'qty': instance.qty,
    };
