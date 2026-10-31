// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemIn _$OrderItemInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OrderItemIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['product_id', 'qty']);
      final val = OrderItemIn(
        productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
        qty: $checkedConvert('qty', (v) => v as num),
      );
      return val;
    }, fieldKeyMap: const {'productId': 'product_id'});

Map<String, dynamic> _$OrderItemInToJson(OrderItemIn instance) =>
    <String, dynamic>{'product_id': instance.productId, 'qty': instance.qty};
