// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentCreate _$PaymentCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PaymentCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['purpose']);
      final val = PaymentCreate(
        purpose: $checkedConvert('purpose', (v) => v as String),
        amount: $checkedConvert('amount', (v) => v as num?),
        orderId: $checkedConvert('order_id', (v) => (v as num?)?.toInt()),
      );
      return val;
    }, fieldKeyMap: const {'orderId': 'order_id'});

Map<String, dynamic> _$PaymentCreateToJson(PaymentCreate instance) =>
    <String, dynamic>{
      'purpose': instance.purpose,
      'amount': ?instance.amount,
      'order_id': ?instance.orderId,
    };
