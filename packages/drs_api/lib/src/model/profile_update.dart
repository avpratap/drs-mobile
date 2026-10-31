//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'profile_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProfileUpdate {
  /// Returns a new [ProfileUpdate] instance.
  ProfileUpdate({

     this.fullName,

     this.displayName,

     this.email,

     this.alternatePhone,

     this.notifyWhatsapp,

     this.notifySms,

     this.notifyPush,

     this.notifyEmail,
  });

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
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    
    name: r'alternate_phone',
    required: false,
    includeIfNull: false,
  )


  final String? alternatePhone;



  @JsonKey(
    
    name: r'notify_whatsapp',
    required: false,
    includeIfNull: false,
  )


  final bool? notifyWhatsapp;



  @JsonKey(
    
    name: r'notify_sms',
    required: false,
    includeIfNull: false,
  )


  final bool? notifySms;



  @JsonKey(
    
    name: r'notify_push',
    required: false,
    includeIfNull: false,
  )


  final bool? notifyPush;



  @JsonKey(
    
    name: r'notify_email',
    required: false,
    includeIfNull: false,
  )


  final bool? notifyEmail;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProfileUpdate &&
      other.fullName == fullName &&
      other.displayName == displayName &&
      other.email == email &&
      other.alternatePhone == alternatePhone &&
      other.notifyWhatsapp == notifyWhatsapp &&
      other.notifySms == notifySms &&
      other.notifyPush == notifyPush &&
      other.notifyEmail == notifyEmail;

    @override
    int get hashCode =>
        fullName.hashCode +
        displayName.hashCode +
        email.hashCode +
        alternatePhone.hashCode +
        notifyWhatsapp.hashCode +
        notifySms.hashCode +
        notifyPush.hashCode +
        notifyEmail.hashCode;

  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => _$ProfileUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

