// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_order_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryOrderOut _$DeliveryOrderOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeliveryOrderOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'delivery_date',
            'shop_id',
            'origin',
            'status',
            'subtotal',
            'total',
            'amount_due',
          ],
        );
        final val = DeliveryOrderOut(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          deliveryDate: $checkedConvert(
            'delivery_date',
            (v) => DateTime.parse(v as String),
          ),
          shopId: $checkedConvert('shop_id', (v) => (v as num).toInt()),
          origin: $checkedConvert('origin', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          subtotal: $checkedConvert('subtotal', (v) => v as num),
          total: $checkedConvert('total', (v) => v as num),
          amountDue: $checkedConvert('amount_due', (v) => v as num),
          failureReason: $checkedConvert('failure_reason', (v) => v as String?),
          items: $checkedConvert(
            'items',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      DeliveryOrderItemOut.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          shopName: $checkedConvert('shop_name', (v) => v as String?),
          address: $checkedConvert('address', (v) => v as String?),
          pincode: $checkedConvert('pincode', (v) => v as String?),
          lat: $checkedConvert('lat', (v) => v as num?),
          lng: $checkedConvert('lng', (v) => v as num?),
          contactName: $checkedConvert('contact_name', (v) => v as String?),
          contactPhone: $checkedConvert('contact_phone', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'deliveryDate': 'delivery_date',
        'shopId': 'shop_id',
        'amountDue': 'amount_due',
        'failureReason': 'failure_reason',
        'shopName': 'shop_name',
        'contactName': 'contact_name',
        'contactPhone': 'contact_phone',
      },
    );

Map<String, dynamic> _$DeliveryOrderOutToJson(DeliveryOrderOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delivery_date': instance.deliveryDate.toIso8601String(),
      'shop_id': instance.shopId,
      'origin': instance.origin,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'total': instance.total,
      'amount_due': instance.amountDue,
      'failure_reason': ?instance.failureReason,
      'items': ?instance.items?.map((e) => e.toJson()).toList(),
      'shop_name': ?instance.shopName,
      'address': ?instance.address,
      'pincode': ?instance.pincode,
      'lat': ?instance.lat,
      'lng': ?instance.lng,
      'contact_name': ?instance.contactName,
      'contact_phone': ?instance.contactPhone,
    };
