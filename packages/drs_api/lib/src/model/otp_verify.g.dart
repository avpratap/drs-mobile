// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPVerify _$OTPVerifyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OTPVerify', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone', 'otp']);
      final val = OTPVerify(
        phone: $checkedConvert('phone', (v) => v as String),
        otp: $checkedConvert('otp', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$OTPVerifyToJson(OTPVerify instance) => <String, dynamic>{
  'phone': instance.phone,
  'otp': instance.otp,
};
