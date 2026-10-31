// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_ratings_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRatingsOut _$ProductRatingsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProductRatingsOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'product_id',
          'count',
          'average',
          'distribution',
          'ratings',
        ],
      );
      final val = ProductRatingsOut(
        productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        average: $checkedConvert('average', (v) => v as num),
        distribution: $checkedConvert(
          'distribution',
          (v) => Map<String, int>.from(v as Map),
        ),
        ratings: $checkedConvert(
          'ratings',
          (v) => (v as List<dynamic>)
              .map((e) => RatingOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'productId': 'product_id'});

Map<String, dynamic> _$ProductRatingsOutToJson(ProductRatingsOut instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'count': instance.count,
      'average': instance.average,
      'distribution': instance.distribution,
      'ratings': instance.ratings.map((e) => e.toJson()).toList(),
    };
