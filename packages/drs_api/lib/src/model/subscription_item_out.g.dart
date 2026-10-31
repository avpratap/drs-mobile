// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_item_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionItemOut _$SubscriptionItemOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionItemOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id', 'product_id', 'default_qty', 'active'],
        );
        final val = SubscriptionItemOut(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
          defaultQty: $checkedConvert('default_qty', (v) => v as num),
          active: $checkedConvert('active', (v) => v as bool),
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

Map<String, dynamic> _$SubscriptionItemOutToJson(
  SubscriptionItemOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'default_qty': instance.defaultQty,
  'active': instance.active,
  'frequency': ?instance.frequency,
  'interval_days': ?instance.intervalDays,
  'days_of_week': ?instance.daysOfWeek,
};
