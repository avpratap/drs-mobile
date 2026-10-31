// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpful_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpfulOut _$HelpfulOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'HelpfulOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['rating_id', 'helpful_count', 'voted'],
    );
    final val = HelpfulOut(
      ratingId: $checkedConvert('rating_id', (v) => (v as num).toInt()),
      helpfulCount: $checkedConvert('helpful_count', (v) => (v as num).toInt()),
      voted: $checkedConvert('voted', (v) => v as bool),
    );
    return val;
  },
  fieldKeyMap: const {'ratingId': 'rating_id', 'helpfulCount': 'helpful_count'},
);

Map<String, dynamic> _$HelpfulOutToJson(HelpfulOut instance) =>
    <String, dynamic>{
      'rating_id': instance.ratingId,
      'helpful_count': instance.helpfulCount,
      'voted': instance.voted,
    };
