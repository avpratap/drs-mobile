// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderCreate _$OrderCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OrderCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = OrderCreate(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => OrderItemIn.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        address: $checkedConvert('address', (v) => v as String?),
        state: $checkedConvert('state', (v) => v as String?),
        pincode: $checkedConvert('pincode', (v) => v as String?),
        couponCode: $checkedConvert('coupon_code', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'couponCode': 'coupon_code'});

Map<String, dynamic> _$OrderCreateToJson(OrderCreate instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'address': ?instance.address,
      'state': ?instance.state,
      'pincode': ?instance.pincode,
      'coupon_code': ?instance.couponCode,
    };
