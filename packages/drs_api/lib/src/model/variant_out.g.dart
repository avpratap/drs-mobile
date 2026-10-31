// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariantOut _$VariantOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'VariantOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'product_id',
        'sku',
        'label',
        'pack_size',
        'price',
        'status',
        'sort_order',
      ],
    );
    final val = VariantOut(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      productId: $checkedConvert('product_id', (v) => (v as num).toInt()),
      sku: $checkedConvert('sku', (v) => v as String),
      label: $checkedConvert('label', (v) => v as String),
      packSize: $checkedConvert('pack_size', (v) => v as num),
      price: $checkedConvert('price', (v) => v as num),
      status: $checkedConvert('status', (v) => v as String),
      sortOrder: $checkedConvert('sort_order', (v) => (v as num).toInt()),
      mrp: $checkedConvert('mrp', (v) => v as num?),
      imageUrl: $checkedConvert('image_url', (v) => v as String?),
      sellingPrice: $checkedConvert('selling_price', (v) => v as num?),
      priceAvailable: $checkedConvert('price_available', (v) => v as bool?),
      showMrpStrike: $checkedConvert(
        'show_mrp_strike',
        (v) => v as bool? ?? false,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'productId': 'product_id',
    'packSize': 'pack_size',
    'sortOrder': 'sort_order',
    'imageUrl': 'image_url',
    'sellingPrice': 'selling_price',
    'priceAvailable': 'price_available',
    'showMrpStrike': 'show_mrp_strike',
  },
);

Map<String, dynamic> _$VariantOutToJson(VariantOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'sku': instance.sku,
      'label': instance.label,
      'pack_size': instance.packSize,
      'price': instance.price,
      'status': instance.status,
      'sort_order': instance.sortOrder,
      'mrp': ?instance.mrp,
      'image_url': ?instance.imageUrl,
      'selling_price': ?instance.sellingPrice,
      'price_available': ?instance.priceAvailable,
      'show_mrp_strike': ?instance.showMrpStrike,
    };
