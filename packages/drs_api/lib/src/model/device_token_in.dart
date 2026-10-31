//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_token_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceTokenIn {
  /// Returns a new [DeviceTokenIn] instance.
  DeviceTokenIn({

    required  this.token,

     this.platform = 'android',
  });

      /// FCM registration token (PII)
  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: false,
  )


  final String token;



      /// ios | android | web
  @JsonKey(
    defaultValue: 'android',
    name: r'platform',
    required: false,
    includeIfNull: false,
  )


  final String? platform;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceTokenIn &&
      other.token == token &&
      other.platform == platform;

    @override
    int get hashCode =>
        token.hashCode +
        platform.hashCode;

  factory DeviceTokenIn.fromJson(Map<String, dynamic> json) => _$DeviceTokenInFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTokenInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

