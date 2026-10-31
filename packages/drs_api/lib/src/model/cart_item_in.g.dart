// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemIn _$CartItemInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CartItemIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['product_id', 'qty']);
      final val = CartItemIn(
        productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
        qty: $checkedConvert('qty', (v) => v as num),
      );
      return val;
    }, fieldKeyMap: const {'productId': 'product_id'});

Map<String, dynamic> _$CartItemInToJson(CartItemIn instance) =>
    <String, dynamic>{'product_id': instance.productId, 'qty': instance.qty};
