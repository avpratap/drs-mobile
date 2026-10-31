//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'token_pair.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TokenPair {
  /// Returns a new [TokenPair] instance.
  TokenPair({

    required  this.accessToken,

    required  this.refreshToken,

     this.tokenType = 'bearer',
  });

  @JsonKey(
    
    name: r'access_token',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'refresh_token',
    required: true,
    includeIfNull: false,
  )


  final String refreshToken;



  @JsonKey(
    defaultValue: 'bearer',
    name: r'token_type',
    required: false,
    includeIfNull: false,
  )


  final String? tokenType;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TokenPair &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.tokenType == tokenType;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        tokenType.hashCode;

  factory TokenPair.fromJson(Map<String, dynamic> json) => _$TokenPairFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPairToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

