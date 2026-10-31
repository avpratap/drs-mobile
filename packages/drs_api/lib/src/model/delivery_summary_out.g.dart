// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_summary_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverySummaryOut _$DeliverySummaryOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeliverySummaryOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'date',
          'delivered',
          'failed',
          'pending',
          'cash_collected',
        ],
      );
      final val = DeliverySummaryOut(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        delivered: $checkedConvert('delivered', (v) => (v as num).toInt()),
        failed: $checkedConvert('failed', (v) => (v as num).toInt()),
        pending: $checkedConvert('pending', (v) => (v as num).toInt()),
        cashCollected: $checkedConvert('cash_collected', (v) => v as num),
      );
      return val;
    }, fieldKeyMap: const {'cashCollected': 'cash_collected'});

Map<String, dynamic> _$DeliverySummaryOutToJson(DeliverySummaryOut instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'delivered': instance.delivered,
      'failed': instance.failed,
      'pending': instance.pending,
      'cash_collected': instance.cashCollected,
    };
