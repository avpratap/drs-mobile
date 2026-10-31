//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'otp_verify.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OTPVerify {
  /// Returns a new [OTPVerify] instance.
  OTPVerify({

    required  this.phone,

    required  this.otp,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'otp',
    required: true,
    includeIfNull: false,
  )


  final String otp;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OTPVerify &&
      other.phone == phone &&
      other.otp == otp;

    @override
    int get hashCode =>
        phone.hashCode +
        otp.hashCode;

  factory OTPVerify.fromJson(Map<String, dynamic> json) => _$OTPVerifyFromJson(json);

  Map<String, dynamic> toJson() => _$OTPVerifyToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

