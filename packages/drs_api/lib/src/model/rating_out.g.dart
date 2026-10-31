// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingOut _$RatingOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'RatingOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'product_id',
        'stars',
        'status',
        'verified_purchase',
        'helpful_count',
      ],
    );
    final val = RatingOut(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
      stars: $checkedConvert('stars', (v) => (v as num).toInt()),
      status: $checkedConvert('status', (v) => v as String),
      verifiedPurchase: $checkedConvert('verified_purchase', (v) => v as bool),
      helpfulCount: $checkedConvert('helpful_count', (v) => (v as num).toInt()),
      userId: $checkedConvert('user_id', (v) => (v as num?)?.toInt()),
      mine: $checkedConvert('mine', (v) => v as bool? ?? false),
      comment: $checkedConvert('comment', (v) => v as String?),
      adminReply: $checkedConvert('admin_reply', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'productId': 'product_id',
    'verifiedPurchase': 'verified_purchase',
    'helpfulCount': 'helpful_count',
    'userId': 'user_id',
    'adminReply': 'admin_reply',
  },
);

Map<String, dynamic> _$RatingOutToJson(RatingOut instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'stars': instance.stars,
  'status': instance.status,
  'verified_purchase': instance.verifiedPurchase,
  'helpful_count': instance.helpfulCount,
  'user_id': ?instance.userId,
  'mine': ?instance.mine,
  'comment': ?instance.comment,
  'admin_reply': ?instance.adminReply,
};
