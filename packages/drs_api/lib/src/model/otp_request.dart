//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'otp_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OTPRequest {
  /// Returns a new [OTPRequest] instance.
  OTPRequest({

    required  this.phone,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OTPRequest &&
      other.phone == phone;

    @override
    int get hashCode =>
        phone.hashCode;

  factory OTPRequest.fromJson(Map<String, dynamic> json) => _$OTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OTPRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

