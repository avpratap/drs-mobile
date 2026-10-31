// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_verify_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentVerifyOut _$PaymentVerifyOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PaymentVerifyOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['detail', 'payment_id', 'status']);
      final val = PaymentVerifyOut(
        detail: $checkedConvert('detail', (v) => v as String),
        paymentId: $checkedConvert('payment_id', (v) => (v as num).toInt()),
        status: $checkedConvert('status', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'paymentId': 'payment_id'});

Map<String, dynamic> _$PaymentVerifyOutToJson(PaymentVerifyOut instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'payment_id': instance.paymentId,
      'status': instance.status,
    };
