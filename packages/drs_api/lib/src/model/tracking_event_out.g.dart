// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_event_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingEventOut _$TrackingEventOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrackingEventOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status']);
      final val = TrackingEventOut(
        status: $checkedConvert('status', (v) => v as String),
        location: $checkedConvert('location', (v) => v as String?),
        note: $checkedConvert('note', (v) => v as String?),
        eventTime: $checkedConvert(
          'event_time',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    }, fieldKeyMap: const {'eventTime': 'event_time'});

Map<String, dynamic> _$TrackingEventOutToJson(TrackingEventOut instance) =>
    <String, dynamic>{
      'status': instance.status,
      'location': ?instance.location,
      'note': ?instance.note,
      'event_time': ?instance.eventTime?.toIso8601String(),
    };
