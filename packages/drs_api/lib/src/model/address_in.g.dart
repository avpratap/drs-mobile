// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressIn _$AddressInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AddressIn',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['line1', 'city', 'state', 'pincode']);
    final val = AddressIn(
      line1: $checkedConvert('line1', (v) => v as String),
      city: $checkedConvert('city', (v) => v as String),
      state: $checkedConvert('state', (v) => v as String),
      pincode: $checkedConvert('pincode', (v) => v as String),
      label: $checkedConvert('label', (v) => v as String?),
      contactName: $checkedConvert('contact_name', (v) => v as String?),
      contactPhone: $checkedConvert('contact_phone', (v) => v as String?),
      line2: $checkedConvert('line2', (v) => v as String?),
      landmark: $checkedConvert('landmark', (v) => v as String?),
      country: $checkedConvert('country', (v) => v as String? ?? 'IN'),
      isDefault: $checkedConvert('is_default', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'contactName': 'contact_name',
    'contactPhone': 'contact_phone',
    'isDefault': 'is_default',
  },
);

Map<String, dynamic> _$AddressInToJson(AddressIn instance) => <String, dynamic>{
  'line1': instance.line1,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'label': ?instance.label,
  'contact_name': ?instance.contactName,
  'contact_phone': ?instance.contactPhone,
  'line2': ?instance.line2,
  'landmark': ?instance.landmark,
  'country': ?instance.country,
  'is_default': ?instance.isDefault,
};
