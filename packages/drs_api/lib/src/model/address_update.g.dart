// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressUpdate _$AddressUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AddressUpdate',
      json,
      ($checkedConvert) {
        final val = AddressUpdate(
          label: $checkedConvert('label', (v) => v as String?),
          contactName: $checkedConvert('contact_name', (v) => v as String?),
          contactPhone: $checkedConvert('contact_phone', (v) => v as String?),
          line1: $checkedConvert('line1', (v) => v as String?),
          line2: $checkedConvert('line2', (v) => v as String?),
          landmark: $checkedConvert('landmark', (v) => v as String?),
          city: $checkedConvert('city', (v) => v as String?),
          state: $checkedConvert('state', (v) => v as String?),
          pincode: $checkedConvert('pincode', (v) => v as String?),
          isDefault: $checkedConvert('is_default', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'contactName': 'contact_name',
        'contactPhone': 'contact_phone',
        'isDefault': 'is_default',
      },
    );

Map<String, dynamic> _$AddressUpdateToJson(AddressUpdate instance) =>
    <String, dynamic>{
      'label': ?instance.label,
      'contact_name': ?instance.contactName,
      'contact_phone': ?instance.contactPhone,
      'line1': ?instance.line1,
      'line2': ?instance.line2,
      'landmark': ?instance.landmark,
      'city': ?instance.city,
      'state': ?instance.state,
      'pincode': ?instance.pincode,
      'is_default': ?instance.isDefault,
    };
