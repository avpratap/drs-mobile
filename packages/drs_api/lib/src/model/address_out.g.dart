// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressOut _$AddressOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AddressOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'account_id',
        'line1',
        'city',
        'state',
        'pincode',
        'country',
        'is_default',
        'status',
      ],
    );
    final val = AddressOut(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
      line1: $checkedConvert('line1', (v) => v as String),
      city: $checkedConvert('city', (v) => v as String),
      state: $checkedConvert('state', (v) => v as String),
      pincode: $checkedConvert('pincode', (v) => v as String),
      country: $checkedConvert('country', (v) => v as String),
      isDefault: $checkedConvert('is_default', (v) => v as bool),
      status: $checkedConvert('status', (v) => v as String),
      label: $checkedConvert('label', (v) => v as String?),
      contactName: $checkedConvert('contact_name', (v) => v as String?),
      contactPhone: $checkedConvert('contact_phone', (v) => v as String?),
      line2: $checkedConvert('line2', (v) => v as String?),
      landmark: $checkedConvert('landmark', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'accountId': 'account_id',
    'isDefault': 'is_default',
    'contactName': 'contact_name',
    'contactPhone': 'contact_phone',
  },
);

Map<String, dynamic> _$AddressOutToJson(AddressOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'line1': instance.line1,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'country': instance.country,
      'is_default': instance.isDefault,
      'status': instance.status,
      'label': ?instance.label,
      'contact_name': ?instance.contactName,
      'contact_phone': ?instance.contactPhone,
      'line2': ?instance.line2,
      'landmark': ?instance.landmark,
    };
