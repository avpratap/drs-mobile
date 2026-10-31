//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_token_unregister_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceTokenUnregisterIn {
  /// Returns a new [DeviceTokenUnregisterIn] instance.
  DeviceTokenUnregisterIn({

    required  this.token,
  });

  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: false,
  )


  final String token;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceTokenUnregisterIn &&
      other.token == token;

    @override
    int get hashCode =>
        token.hashCode;

  factory DeviceTokenUnregisterIn.fromJson(Map<String, dynamic> json) => _$DeviceTokenUnregisterInFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTokenUnregisterInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

