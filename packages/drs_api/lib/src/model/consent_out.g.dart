// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentOut _$ConsentOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConsentOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'purpose', 'action', 'source', 'created_at'],
      );
      final val = ConsentOut(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        purpose: $checkedConvert('purpose', (v) => v as String),
        action: $checkedConvert('action', (v) => v as String),
        source_: $checkedConvert('source', (v) => v as String),
        createdAt: $checkedConvert(
          'created_at',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    }, fieldKeyMap: const {'source_': 'source', 'createdAt': 'created_at'});

Map<String, dynamic> _$ConsentOutToJson(ConsentOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purpose': instance.purpose,
      'action': instance.action,
      'source': instance.source_,
      'created_at': instance.createdAt.toIso8601String(),
    };
