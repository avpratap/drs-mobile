// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOut _$UserOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'phone', 'role', 'status']);
      final val = UserOut(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        phone: $checkedConvert('phone', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        fullName: $checkedConvert('full_name', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'fullName': 'full_name'});

Map<String, dynamic> _$UserOutToJson(UserOut instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'role': instance.role,
  'status': instance.status,
  'full_name': ?instance.fullName,
};
