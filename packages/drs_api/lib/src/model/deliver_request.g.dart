// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliver_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverRequest _$DeliverRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeliverRequest',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['items']);
        final val = DeliverRequest(
          items: $checkedConvert(
            'items',
            (v) => (v as List<dynamic>)
                .map((e) => DeliverItem.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          pod: $checkedConvert(
            'pod',
            (v) => v == null ? null : PODIn.fromJson(v as Map<String, dynamic>),
          ),
          cashCollected: $checkedConvert('cash_collected', (v) => v as num?),
          cashMethod: $checkedConvert('cash_method', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'cashCollected': 'cash_collected',
        'cashMethod': 'cash_method',
      },
    );

Map<String, dynamic> _$DeliverRequestToJson(DeliverRequest instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'pod': ?instance.pod?.toJson(),
      'cash_collected': ?instance.cashCollected,
      'cash_method': ?instance.cashMethod,
    };
