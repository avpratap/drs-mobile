// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutIn _$CheckoutInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CheckoutIn', json, ($checkedConvert) {
      final val = CheckoutIn(
        address: $checkedConvert('address', (v) => v as String?),
        state: $checkedConvert('state', (v) => v as String?),
        pincode: $checkedConvert('pincode', (v) => v as String?),
        couponCode: $checkedConvert('coupon_code', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'couponCode': 'coupon_code'});

Map<String, dynamic> _$CheckoutInToJson(CheckoutIn instance) =>
    <String, dynamic>{
      'address': ?instance.address,
      'state': ?instance.state,
      'pincode': ?instance.pincode,
      'coupon_code': ?instance.couponCode,
    };
