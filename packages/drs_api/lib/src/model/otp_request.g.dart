// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPRequest _$OTPRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
  'OTPRequest',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['phone']);
    final val = OTPRequest(phone: $checkedConvert('phone', (v) => v as String));
    return val;
  },
);

Map<String, dynamic> _$OTPRequestToJson(OTPRequest instance) =>
    <String, dynamic>{'phone': instance.phone};
