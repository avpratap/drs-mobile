// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_create_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentCreateOut _$PaymentCreateOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PaymentCreateOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'payment_id',
            'gateway_order_id',
            'amount',
            'key_id',
          ],
        );
        final val = PaymentCreateOut(
          paymentId: $checkedConvert('payment_id', (v) => (v as num).toInt()),
          gatewayOrderId: $checkedConvert(
            'gateway_order_id',
            (v) => v as String,
          ),
          amount: $checkedConvert('amount', (v) => v as num),
          keyId: $checkedConvert('key_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'paymentId': 'payment_id',
        'gatewayOrderId': 'gateway_order_id',
        'keyId': 'key_id',
      },
    );

Map<String, dynamic> _$PaymentCreateOutToJson(PaymentCreateOut instance) =>
    <String, dynamic>{
      'payment_id': instance.paymentId,
      'gateway_order_id': instance.gatewayOrderId,
      'amount': instance.amount,
      'key_id': instance.keyId,
    };
