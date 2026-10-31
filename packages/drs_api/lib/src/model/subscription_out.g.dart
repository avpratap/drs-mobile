// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionOut _$SubscriptionOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionOut',
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
        final val = SubscriptionOut(
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

Map<String, dynamic> _$SubscriptionOutToJson(SubscriptionOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'account_id': instance.accountId,
      'status': instance.status,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': ?instance.endDate?.toIso8601String(),
    };
