// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_error_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationErrorItem _$ValidationErrorItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ValidationErrorItem', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['loc', 'msg', 'type']);
      final val = ValidationErrorItem(
        loc: $checkedConvert(
          'loc',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        msg: $checkedConvert('msg', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ValidationErrorItemToJson(
  ValidationErrorItem instance,
) => <String, dynamic>{
  'loc': instance.loc,
  'msg': instance.msg,
  'type': instance.type,
};
