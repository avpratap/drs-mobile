// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanOut _$PlanOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'PlanOut',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['for_date', 'lines']);
    final val = PlanOut(
      forDate: $checkedConvert('for_date', (v) => DateTime.parse(v as String)),
      lines: $checkedConvert(
        'lines',
        (v) => (v as List<dynamic>)
            .map((e) => PlanLine.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'forDate': 'for_date'},
);

Map<String, dynamic> _$PlanOutToJson(PlanOut instance) => <String, dynamic>{
  'for_date': instance.forDate.toIso8601String(),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
};
