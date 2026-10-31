// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceTokenOut _$DeviceTokenOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceTokenOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token', 'platform', 'active']);
      final val = DeviceTokenOut(
        token: $checkedConvert('token', (v) => v as String),
        platform: $checkedConvert('platform', (v) => v as String),
        active: $checkedConvert('active', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$DeviceTokenOutToJson(DeviceTokenOut instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': instance.platform,
      'active': instance.active,
    };
