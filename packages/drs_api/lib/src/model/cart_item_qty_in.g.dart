// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_qty_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemQtyIn _$CartItemQtyInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CartItemQtyIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['qty']);
      final val = CartItemQtyIn(qty: $checkedConvert('qty', (v) => v as num));
      return val;
    });

Map<String, dynamic> _$CartItemQtyInToJson(CartItemQtyIn instance) =>
    <String, dynamic>{'qty': instance.qty};
