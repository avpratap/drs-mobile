// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionCreate _$SubscriptionCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionCreate',
      json,
      ($checkedConvert) {
        final val = SubscriptionCreate(
          shopId: $checkedConvert('shop_id', (v) => (v as num?)?.toInt()),
          homeName: $checkedConvert('home_name', (v) => v as String?),
          homeAddress: $checkedConvert('home_address', (v) => v as String?),
          homeState: $checkedConvert('home_state', (v) => v as String?),
          homePincode: $checkedConvert('home_pincode', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'shopId': 'shop_id',
        'homeName': 'home_name',
        'homeAddress': 'home_address',
        'homeState': 'home_state',
        'homePincode': 'home_pincode',
      },
    );

Map<String, dynamic> _$SubscriptionCreateToJson(SubscriptionCreate instance) =>
    <String, dynamic>{
      'shop_id': ?instance.shopId,
      'home_name': ?instance.homeName,
      'home_address': ?instance.homeAddress,
      'home_state': ?instance.homeState,
      'home_pincode': ?instance.homePincode,
    };
