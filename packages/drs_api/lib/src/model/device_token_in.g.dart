// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceTokenIn _$DeviceTokenInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceTokenIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token']);
      final val = DeviceTokenIn(
        token: $checkedConvert('token', (v) => v as String),
        platform: $checkedConvert('platform', (v) => v as String? ?? 'android'),
      );
      return val;
    });

Map<String, dynamic> _$DeviceTokenInToJson(DeviceTokenIn instance) =>
    <String, dynamic>{'token': instance.token, 'platform': ?instance.platform};
