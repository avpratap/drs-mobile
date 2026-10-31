//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'profile_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProfileOut {
  /// Returns a new [ProfileOut] instance.
  ProfileOut({

    required  this.userId,

    required  this.phone,

     this.email,

     this.emailVerified = false,

     this.fullName,

     this.displayName,

     this.avatarUrl,

     this.locale = 'en-IN',

     this.notifyWhatsapp = false,

     this.notifySms = true,

     this.notifyPush = true,

     this.notifyEmail = false,

     this.marketingOptIn = false,
  });

  @JsonKey(
    
    name: r'user_id',
    required: true,
    includeIfNull: false,
  )


  final int userId;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    defaultValue: false,
    name: r'email_verified',
    required: false,
    includeIfNull: false,
  )


  final bool? emailVerified;



  @JsonKey(
    
    name: r'full_name',
    required: false,
    includeIfNull: false,
  )


  final String? fullName;



  @JsonKey(
    
    name: r'display_name',
    required: false,
    includeIfNull: false,
  )


  final String? displayName;



  @JsonKey(
    
    name: r'avatar_url',
    required: false,
    includeIfNull: false,
  )


  final String? avatarUrl;



  @JsonKey(
    defaultValue: 'en-IN',
    name: r'locale',
    required: false,
    includeIfNull: false,
  )


  final String? locale;



  @JsonKey(
    defaultValue: false,
    name: r'notify_whatsapp',
    required: false,
    includeIfNull: false,
  )


  final bool? notifyWhatsapp;



  @JsonKey(
    defaultValue: true,
    name: r'notify_sms',
    required: false,
    includeIfNull: false,
  )


  final bool? notifySms;



  @JsonKey(
    defaultValue: true,
    name: r'notify_push',
    required: false,
    includeIfNull: false,
  )


  final bool? notifyPush;



  @JsonKey(
    defaultValue: false,
    name: r'notify_email',
    required: false,
    includeIfNull: false,
  )


  final bool? notifyEmail;



  @JsonKey(
    defaultValue: false,
    name: r'marketing_opt_in',
    required: false,
    includeIfNull: false,
  )


  final bool? marketingOptIn;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProfileOut &&
      other.userId == userId &&
      other.phone == phone &&
      other.email == email &&
      other.emailVerified == emailVerified &&
      other.fullName == fullName &&
      other.displayName == displayName &&
      other.avatarUrl == avatarUrl &&
      other.locale == locale &&
      other.notifyWhatsapp == notifyWhatsapp &&
      other.notifySms == notifySms &&
      other.notifyPush == notifyPush &&
      other.notifyEmail == notifyEmail &&
      other.marketingOptIn == marketingOptIn;

    @override
    int get hashCode =>
        userId.hashCode +
        phone.hashCode +
        email.hashCode +
        emailVerified.hashCode +
        fullName.hashCode +
        displayName.hashCode +
        avatarUrl.hashCode +
        locale.hashCode +
        notifyWhatsapp.hashCode +
        notifySms.hashCode +
        notifyPush.hashCode +
        notifyEmail.hashCode +
        marketingOptIn.hashCode;

  factory ProfileOut.fromJson(Map<String, dynamic> json) => _$ProfileOutFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

