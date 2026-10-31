// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_track_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentTrackOut _$ShipmentTrackOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShipmentTrackOut',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['id', 'shipment_no', 'status']);
        final val = ShipmentTrackOut(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          shipmentNo: $checkedConvert('shipment_no', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          courier: $checkedConvert('courier', (v) => v as String?),
          awb: $checkedConvert('awb', (v) => v as String?),
          trackingUrl: $checkedConvert('tracking_url', (v) => v as String?),
          events: $checkedConvert(
            'events',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => TrackingEventOut.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'shipmentNo': 'shipment_no',
        'trackingUrl': 'tracking_url',
      },
    );

Map<String, dynamic> _$ShipmentTrackOutToJson(ShipmentTrackOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shipment_no': instance.shipmentNo,
      'status': instance.status,
      'courier': ?instance.courier,
      'awb': ?instance.awb,
      'tracking_url': ?instance.trackingUrl,
      'events': ?instance.events?.map((e) => e.toJson()).toList(),
    };
