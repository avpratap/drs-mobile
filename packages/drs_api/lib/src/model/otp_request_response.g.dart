// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPRequestResponse _$OTPRequestResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OTPRequestResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['detail']);
      final val = OTPRequestResponse(
        detail: $checkedConvert('detail', (v) => v as String),
        devOtp: $checkedConvert('dev_otp', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'devOtp': 'dev_otp'});

Map<String, dynamic> _$OTPRequestResponseToJson(OTPRequestResponse instance) =>
    <String, dynamic>{'detail': instance.detail, 'dev_otp': ?instance.devOtp};
