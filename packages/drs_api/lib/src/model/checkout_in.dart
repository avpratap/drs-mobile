//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'checkout_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CheckoutIn {
  /// Returns a new [CheckoutIn] instance.
  CheckoutIn({

     this.address,

     this.state,

     this.pincode,

     this.couponCode,
  });

  @JsonKey(
    
    name: r'address',
    required: false,
    includeIfNull: false,
  )


  final String? address;



  @JsonKey(
    
    name: r'state',
    required: false,
    includeIfNull: false,
  )


  final String? state;



  @JsonKey(
    
    name: r'pincode',
    required: false,
    includeIfNull: false,
  )


  final String? pincode;



  @JsonKey(
    
    name: r'coupon_code',
    required: false,
    includeIfNull: false,
  )


  final String? couponCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CheckoutIn &&
      other.address == address &&
      other.state == state &&
      other.pincode == pincode &&
      other.couponCode == couponCode;

    @override
    int get hashCode =>
        address.hashCode +
        state.hashCode +
        pincode.hashCode +
        couponCode.hashCode;

  factory CheckoutIn.fromJson(Map<String, dynamic> json) => _$CheckoutInFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

