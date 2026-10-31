//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/delivery_order_item_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_order_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeliveryOrderOut {
  /// Returns a new [DeliveryOrderOut] instance.
  DeliveryOrderOut({

    required  this.id,

    required  this.deliveryDate,

    required  this.shopId,

    required  this.origin,

    required  this.status,

    required  this.subtotal,

    required  this.total,

    required  this.amountDue,

     this.failureReason,

     this.items,

     this.shopName,

     this.address,

     this.pincode,

     this.lat,

     this.lng,

     this.contactName,

     this.contactPhone,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'delivery_date',
    required: true,
    includeIfNull: false,
  )


  final DateTime deliveryDate;



  @JsonKey(
    
    name: r'shop_id',
    required: true,
    includeIfNull: false,
  )


  final int shopId;



  @JsonKey(
    
    name: r'origin',
    required: true,
    includeIfNull: false,
  )


  final String origin;



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
    
    name: r'amount_due',
    required: true,
    includeIfNull: false,
  )


  final num amountDue;



  @JsonKey(
    
    name: r'failure_reason',
    required: false,
    includeIfNull: false,
  )


  final String? failureReason;



  @JsonKey(
    
    name: r'items',
    required: false,
    includeIfNull: false,
  )


  final List<DeliveryOrderItemOut>? items;



  @JsonKey(
    
    name: r'shop_name',
    required: false,
    includeIfNull: false,
  )


  final String? shopName;



  @JsonKey(
    
    name: r'address',
    required: false,
    includeIfNull: false,
  )


  final String? address;



  @JsonKey(
    
    name: r'pincode',
    required: false,
    includeIfNull: false,
  )


  final String? pincode;



  @JsonKey(
    
    name: r'lat',
    required: false,
    includeIfNull: false,
  )


  final num? lat;



  @JsonKey(
    
    name: r'lng',
    required: false,
    includeIfNull: false,
  )


  final num? lng;



  @JsonKey(
    
    name: r'contact_name',
    required: false,
    includeIfNull: false,
  )


  final String? contactName;



  @JsonKey(
    
    name: r'contact_phone',
    required: false,
    includeIfNull: false,
  )


  final String? contactPhone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeliveryOrderOut &&
      other.id == id &&
      other.deliveryDate == deliveryDate &&
      other.shopId == shopId &&
      other.origin == origin &&
      other.status == status &&
      other.subtotal == subtotal &&
      other.total == total &&
      other.amountDue == amountDue &&
      other.failureReason == failureReason &&
      other.items == items &&
      other.shopName == shopName &&
      other.address == address &&
      other.pincode == pincode &&
      other.lat == lat &&
      other.lng == lng &&
      other.contactName == contactName &&
      other.contactPhone == contactPhone;

    @override
    int get hashCode =>
        id.hashCode +
        deliveryDate.hashCode +
        shopId.hashCode +
        origin.hashCode +
        status.hashCode +
        subtotal.hashCode +
        total.hashCode +
        amountDue.hashCode +
        failureReason.hashCode +
        items.hashCode +
        shopName.hashCode +
        address.hashCode +
        pincode.hashCode +
        lat.hashCode +
        lng.hashCode +
        contactName.hashCode +
        contactPhone.hashCode;

  factory DeliveryOrderOut.fromJson(Map<String, dynamic> json) => _$DeliveryOrderOutFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOrderOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

