// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_unregister_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceTokenUnregisterIn _$DeviceTokenUnregisterInFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceTokenUnregisterIn', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['token']);
  final val = DeviceTokenUnregisterIn(
    token: $checkedConvert('token', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$DeviceTokenUnregisterInToJson(
  DeviceTokenUnregisterIn instance,
) => <String, dynamic>{'token': instance.token};
