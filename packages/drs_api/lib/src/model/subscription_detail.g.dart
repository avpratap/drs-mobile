// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionDetail _$SubscriptionDetailFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionDetail',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'shop_id',
            'account_id',
            'status',
            'start_date',
          ],
        );
        final val = SubscriptionDetail(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          shopId: $checkedConvert('shop_id', (v) => (v as num).toInt()),
          accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
          status: $checkedConvert('status', (v) => v as String),
          startDate: $checkedConvert(
            'start_date',
            (v) => DateTime.parse(v as String),
          ),
          endDate: $checkedConvert(
            'end_date',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          items: $checkedConvert(
            'items',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      SubscriptionItemOut.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'shopId': 'shop_id',
        'accountId': 'account_id',
        'startDate': 'start_date',
        'endDate': 'end_date',
      },
    );

Map<String, dynamic> _$SubscriptionDetailToJson(SubscriptionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'account_id': instance.accountId,
      'status': instance.status,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': ?instance.endDate?.toIso8601String(),
      'items': ?instance.items?.map((e) => e.toJson()).toList(),
    };
