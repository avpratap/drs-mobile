// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileUpdate _$ProfileUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProfileUpdate',
      json,
      ($checkedConvert) {
        final val = ProfileUpdate(
          fullName: $checkedConvert('full_name', (v) => v as String?),
          displayName: $checkedConvert('display_name', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          alternatePhone: $checkedConvert(
            'alternate_phone',
            (v) => v as String?,
          ),
          notifyWhatsapp: $checkedConvert('notify_whatsapp', (v) => v as bool?),
          notifySms: $checkedConvert('notify_sms', (v) => v as bool?),
          notifyPush: $checkedConvert('notify_push', (v) => v as bool?),
          notifyEmail: $checkedConvert('notify_email', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'fullName': 'full_name',
        'displayName': 'display_name',
        'alternatePhone': 'alternate_phone',
        'notifyWhatsapp': 'notify_whatsapp',
        'notifySms': 'notify_sms',
        'notifyPush': 'notify_push',
        'notifyEmail': 'notify_email',
      },
    );

Map<String, dynamic> _$ProfileUpdateToJson(ProfileUpdate instance) =>
    <String, dynamic>{
      'full_name': ?instance.fullName,
      'display_name': ?instance.displayName,
      'email': ?instance.email,
      'alternate_phone': ?instance.alternatePhone,
      'notify_whatsapp': ?instance.notifyWhatsapp,
      'notify_sms': ?instance.notifySms,
      'notify_push': ?instance.notifyPush,
      'notify_email': ?instance.notifyEmail,
    };
