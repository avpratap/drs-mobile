//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_create.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionCreate {
  /// Returns a new [SubscriptionCreate] instance.
  SubscriptionCreate({

     this.shopId,

     this.homeName,

     this.homeAddress,

     this.homeState,

     this.homePincode,
  });

  @JsonKey(
    
    name: r'shop_id',
    required: false,
    includeIfNull: false,
  )


  final int? shopId;



  @JsonKey(
    
    name: r'home_name',
    required: false,
    includeIfNull: false,
  )


  final String? homeName;



  @JsonKey(
    
    name: r'home_address',
    required: false,
    includeIfNull: false,
  )


  final String? homeAddress;



  @JsonKey(
    
    name: r'home_state',
    required: false,
    includeIfNull: false,
  )


  final String? homeState;



  @JsonKey(
    
    name: r'home_pincode',
    required: false,
    includeIfNull: false,
  )


  final String? homePincode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SubscriptionCreate &&
      other.shopId == shopId &&
      other.homeName == homeName &&
      other.homeAddress == homeAddress &&
      other.homeState == homeState &&
      other.homePincode == homePincode;

    @override
    int get hashCode =>
        shopId.hashCode +
        homeName.hashCode +
        homeAddress.hashCode +
        homeState.hashCode +
        homePincode.hashCode;

  factory SubscriptionCreate.fromJson(Map<String, dynamic> json) => _$SubscriptionCreateFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

