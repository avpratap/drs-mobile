// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PODIn _$PODInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'PODIn',
  json,
  ($checkedConvert) {
    final val = PODIn(
      recipientName: $checkedConvert('recipient_name', (v) => v as String?),
      photoUrl: $checkedConvert('photo_url', (v) => v as String?),
      signatureUrl: $checkedConvert('signature_url', (v) => v as String?),
      lat: $checkedConvert('lat', (v) => v as num?),
      lng: $checkedConvert('lng', (v) => v as num?),
      note: $checkedConvert('note', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'recipientName': 'recipient_name',
    'photoUrl': 'photo_url',
    'signatureUrl': 'signature_url',
  },
);

Map<String, dynamic> _$PODInToJson(PODIn instance) => <String, dynamic>{
  'recipient_name': ?instance.recipientName,
  'photo_url': ?instance.photoUrl,
  'signature_url': ?instance.signatureUrl,
  'lat': ?instance.lat,
  'lng': ?instance.lng,
  'note': ?instance.note,
};
