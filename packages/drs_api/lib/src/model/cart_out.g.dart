// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartOut _$CartOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CartOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'status', 'subtotal']);
      final val = CartOut(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        status: $checkedConvert('status', (v) => v as String),
        subtotal: $checkedConvert('subtotal', (v) => v as num),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>?)
              ?.map((e) => CartLineOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CartOutToJson(CartOut instance) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'subtotal': instance.subtotal,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
};
