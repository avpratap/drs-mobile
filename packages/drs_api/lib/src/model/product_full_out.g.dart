// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_full_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductFullOut _$ProductFullOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProductFullOut',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['id', 'sku', 'name', 'status']);
        final val = ProductFullOut(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          sku: $checkedConvert('sku', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          uom: $checkedConvert('uom', (v) => v as String? ?? 'piece'),
          packSize: $checkedConvert('pack_size', (v) => v as num? ?? 1),
          isSubscribable: $checkedConvert(
            'is_subscribable',
            (v) => v as bool? ?? true,
          ),
          perishable: $checkedConvert('perishable', (v) => v as bool? ?? true),
          gstRate: $checkedConvert('gst_rate', (v) => v as num? ?? 0),
          category: $checkedConvert('category', (v) => v as String?),
          imageUrl: $checkedConvert('image_url', (v) => v as String?),
          fromPrice: $checkedConvert('from_price', (v) => v as num?),
          avgRating: $checkedConvert('avg_rating', (v) => v as num? ?? 0),
          ratingCount: $checkedConvert(
            'rating_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          variants: $checkedConvert(
            'variants',
            (v) => (v as List<dynamic>?)
                ?.map((e) => VariantOut.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'packSize': 'pack_size',
        'isSubscribable': 'is_subscribable',
        'gstRate': 'gst_rate',
        'imageUrl': 'image_url',
        'fromPrice': 'from_price',
        'avgRating': 'avg_rating',
        'ratingCount': 'rating_count',
      },
    );

Map<String, dynamic> _$ProductFullOutToJson(ProductFullOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'status': instance.status,
      'description': ?instance.description,
      'uom': ?instance.uom,
      'pack_size': ?instance.packSize,
      'is_subscribable': ?instance.isSubscribable,
      'perishable': ?instance.perishable,
      'gst_rate': ?instance.gstRate,
      'category': ?instance.category,
      'image_url': ?instance.imageUrl,
      'from_price': ?instance.fromPrice,
      'avg_rating': ?instance.avgRating,
      'rating_count': ?instance.ratingCount,
      'variants': ?instance.variants?.map((e) => e.toJson()).toList(),
    };
