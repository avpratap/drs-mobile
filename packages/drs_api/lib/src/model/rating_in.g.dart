// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingIn _$RatingInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RatingIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['stars']);
      final val = RatingIn(
        stars: $checkedConvert('stars', (v) => (v as num).toInt()),
        comment: $checkedConvert('comment', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RatingInToJson(RatingIn instance) => <String, dynamic>{
  'stars': instance.stars,
  'comment': ?instance.comment,
};
