// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentIn _$ConsentInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConsentIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['purpose', 'action']);
      final val = ConsentIn(
        purpose: $checkedConvert('purpose', (v) => v as String),
        action: $checkedConvert('action', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ConsentInToJson(ConsentIn instance) => <String, dynamic>{
  'purpose': instance.purpose,
  'action': instance.action,
};
