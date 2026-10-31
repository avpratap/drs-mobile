// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_verify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentVerify _$PaymentVerifyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PaymentVerify',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'gateway_order_id',
            'gateway_payment_id',
            'signature',
          ],
        );
        final val = PaymentVerify(
          gatewayOrderId: $checkedConvert(
            'gateway_order_id',
            (v) => v as String,
          ),
          gatewayPaymentId: $checkedConvert(
            'gateway_payment_id',
            (v) => v as String,
          ),
          signature: $checkedConvert('signature', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'gatewayOrderId': 'gateway_order_id',
        'gatewayPaymentId': 'gateway_payment_id',
      },
    );

Map<String, dynamic> _$PaymentVerifyToJson(PaymentVerify instance) =>
    <String, dynamic>{
      'gateway_order_id': instance.gatewayOrderId,
      'gateway_payment_id': instance.gatewayPaymentId,
      'signature': instance.signature,
    };
