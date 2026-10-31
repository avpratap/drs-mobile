// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TokenPair',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['access_token', 'refresh_token']);
    final val = TokenPair(
      accessToken: $checkedConvert('access_token', (v) => v as String),
      refreshToken: $checkedConvert('refresh_token', (v) => v as String),
      tokenType: $checkedConvert('token_type', (v) => v as String? ?? 'bearer'),
    );
    return val;
  },
  fieldKeyMap: const {
    'accessToken': 'access_token',
    'refreshToken': 'refresh_token',
    'tokenType': 'token_type',
  },
);

Map<String, dynamic> _$TokenPairToJson(TokenPair instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'token_type': ?instance.tokenType,
};
