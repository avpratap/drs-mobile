// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileOut _$ProfileOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ProfileOut',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['user_id', 'phone']);
    final val = ProfileOut(
      userId: $checkedConvert('user_id', (v) => (v as num).toInt()),
      phone: $checkedConvert('phone', (v) => v as String),
      email: $checkedConvert('email', (v) => v as String?),
      emailVerified: $checkedConvert(
        'email_verified',
        (v) => v as bool? ?? false,
      ),
      fullName: $checkedConvert('full_name', (v) => v as String?),
      displayName: $checkedConvert('display_name', (v) => v as String?),
      avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
      locale: $checkedConvert('locale', (v) => v as String? ?? 'en-IN'),
      notifyWhatsapp: $checkedConvert(
        'notify_whatsapp',
        (v) => v as bool? ?? false,
      ),
      notifySms: $checkedConvert('notify_sms', (v) => v as bool? ?? true),
      notifyPush: $checkedConvert('notify_push', (v) => v as bool? ?? true),
      notifyEmail: $checkedConvert('notify_email', (v) => v as bool? ?? false),
      marketingOptIn: $checkedConvert(
        'marketing_opt_in',
        (v) => v as bool? ?? false,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'userId': 'user_id',
    'emailVerified': 'email_verified',
    'fullName': 'full_name',
    'displayName': 'display_name',
    'avatarUrl': 'avatar_url',
    'notifyWhatsapp': 'notify_whatsapp',
    'notifySms': 'notify_sms',
    'notifyPush': 'notify_push',
    'notifyEmail': 'notify_email',
    'marketingOptIn': 'marketing_opt_in',
  },
);

Map<String, dynamic> _$ProfileOutToJson(ProfileOut instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'phone': instance.phone,
      'email': ?instance.email,
      'email_verified': ?instance.emailVerified,
      'full_name': ?instance.fullName,
      'display_name': ?instance.displayName,
      'avatar_url': ?instance.avatarUrl,
      'locale': ?instance.locale,
      'notify_whatsapp': ?instance.notifyWhatsapp,
      'notify_sms': ?instance.notifySms,
      'notify_push': ?instance.notifyPush,
      'notify_email': ?instance.notifyEmail,
      'marketing_opt_in': ?instance.marketingOptIn,
    };
