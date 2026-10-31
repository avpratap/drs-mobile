// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_item_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionItemIn _$SubscriptionItemInFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionItemIn',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['product_id', 'default_qty']);
        final val = SubscriptionItemIn(
          productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
          defaultQty: $checkedConvert('default_qty', (v) => v as num),
          frequency: $checkedConvert(
            'frequency',
            (v) => v as String? ?? 'daily',
          ),
          intervalDays: $checkedConvert(
            'interval_days',
            (v) => (v as num?)?.toInt(),
          ),
          daysOfWeek: $checkedConvert('days_of_week', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'productId': 'product_id',
        'defaultQty': 'default_qty',
        'intervalDays': 'interval_days',
        'daysOfWeek': 'days_of_week',
      },
    );

Map<String, dynamic> _$SubscriptionItemInToJson(SubscriptionItemIn instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'default_qty': instance.defaultQty,
      'frequency': ?instance.frequency,
      'interval_days': ?instance.intervalDays,
      'days_of_week': ?instance.daysOfWeek,
    };
