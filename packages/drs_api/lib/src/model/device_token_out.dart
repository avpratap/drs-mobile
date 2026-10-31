//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_token_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceTokenOut {
  /// Returns a new [DeviceTokenOut] instance.
  DeviceTokenOut({

    required  this.token,

    required  this.platform,

    required  this.active,
  });

  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: false,
  )


  final String token;



  @JsonKey(
    
    name: r'platform',
    required: true,
    includeIfNull: false,
  )


  final String platform;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceTokenOut &&
      other.token == token &&
      other.platform == platform &&
      other.active == active;

    @override
    int get hashCode =>
        token.hashCode +
        platform.hashCode +
        active.hashCode;

  factory DeviceTokenOut.fromJson(Map<String, dynamic> json) => _$DeviceTokenOutFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTokenOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

