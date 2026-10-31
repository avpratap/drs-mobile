//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/order_item_in.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_create.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderCreate {
  /// Returns a new [OrderCreate] instance.
  OrderCreate({

    required  this.items,

     this.address,

     this.state,

     this.pincode,

     this.couponCode,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<OrderItemIn> items;



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
    bool operator ==(Object other) => identical(this, other) || other is OrderCreate &&
      other.items == items &&
      other.address == address &&
      other.state == state &&
      other.pincode == pincode &&
      other.couponCode == couponCode;

    @override
    int get hashCode =>
        items.hashCode +
        address.hashCode +
        state.hashCode +
        pincode.hashCode +
        couponCode.hashCode;

  factory OrderCreate.fromJson(Map<String, dynamic> json) => _$OrderCreateFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

