//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'otp_request_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OTPRequestResponse {
  /// Returns a new [OTPRequestResponse] instance.
  OTPRequestResponse({

    required  this.detail,

     this.devOtp,
  });

  @JsonKey(
    
    name: r'detail',
    required: true,
    includeIfNull: false,
  )


  final String detail;



  @JsonKey(
    
    name: r'dev_otp',
    required: false,
    includeIfNull: false,
  )


  final String? devOtp;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OTPRequestResponse &&
      other.detail == detail &&
      other.devOtp == devOtp;

    @override
    int get hashCode =>
        detail.hashCode +
        devOtp.hashCode;

  factory OTPRequestResponse.fromJson(Map<String, dynamic> json) => _$OTPRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OTPRequestResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

