//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/order_item_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderOut {
  /// Returns a new [OrderOut] instance.
  OrderOut({

    required  this.id,

    required  this.orderNo,

    required  this.shopId,

    required  this.orderType,

    required  this.status,

    required  this.subtotal,

    required  this.total,

    required  this.paymentStatus,

     this.discount = 0,

     this.couponCode,

     this.taxTotal = 0,

     this.totalInclTax = 0,

     this.items,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'order_no',
    required: true,
    includeIfNull: false,
  )


  final String orderNo;



  @JsonKey(
    
    name: r'shop_id',
    required: true,
    includeIfNull: false,
  )


  final int shopId;



  @JsonKey(
    
    name: r'order_type',
    required: true,
    includeIfNull: false,
  )


  final String orderType;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'subtotal',
    required: true,
    includeIfNull: false,
  )


  final num subtotal;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final num total;



  @JsonKey(
    
    name: r'payment_status',
    required: true,
    includeIfNull: false,
  )


  final String paymentStatus;



  @JsonKey(
    defaultValue: 0,
    name: r'discount',
    required: false,
    includeIfNull: false,
  )


  final num? discount;



  @JsonKey(
    
    name: r'coupon_code',
    required: false,
    includeIfNull: false,
  )


  final String? couponCode;



  @JsonKey(
    defaultValue: 0,
    name: r'tax_total',
    required: false,
    includeIfNull: false,
  )


  final num? taxTotal;



  @JsonKey(
    defaultValue: 0,
    name: r'total_incl_tax',
    required: false,
    includeIfNull: false,
  )


  final num? totalInclTax;



  @JsonKey(
    
    name: r'items',
    required: false,
    includeIfNull: false,
  )


  final List<OrderItemOut>? items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OrderOut &&
      other.id == id &&
      other.orderNo == orderNo &&
      other.shopId == shopId &&
      other.orderType == orderType &&
      other.status == status &&
      other.subtotal == subtotal &&
      other.total == total &&
      other.paymentStatus == paymentStatus &&
      other.discount == discount &&
      other.couponCode == couponCode &&
      other.taxTotal == taxTotal &&
      other.totalInclTax == totalInclTax &&
      other.items == items;

    @override
    int get hashCode =>
        id.hashCode +
        orderNo.hashCode +
        shopId.hashCode +
        orderType.hashCode +
        status.hashCode +
        subtotal.hashCode +
        total.hashCode +
        paymentStatus.hashCode +
        discount.hashCode +
        couponCode.hashCode +
        taxTotal.hashCode +
        totalInclTax.hashCode +
        items.hashCode;

  factory OrderOut.fromJson(Map<String, dynamic> json) => _$OrderOutFromJson(json);

  Map<String, dynamic> toJson() => _$OrderOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

