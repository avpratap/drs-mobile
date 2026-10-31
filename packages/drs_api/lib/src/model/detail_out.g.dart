// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailOut _$DetailOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DetailOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['detail']);
      final val = DetailOut(
        detail: $checkedConvert('detail', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DetailOutToJson(DetailOut instance) => <String, dynamic>{
  'detail': instance.detail,
};
