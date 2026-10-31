// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fail_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FailIn _$FailInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FailIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = FailIn(reason: $checkedConvert('reason', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$FailInToJson(FailIn instance) => <String, dynamic>{
  'reason': instance.reason,
};
