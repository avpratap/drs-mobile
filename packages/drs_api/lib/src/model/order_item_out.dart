//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'order_item_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderItemOut {
  /// Returns a new [OrderItemOut] instance.
  OrderItemOut({

    required  this.productId,

    required  this.qty,

    required  this.unitPrice,

    required  this.lineTotal,

     this.gstRate = 0,

     this.gstAmount = 0,

     this.priceInclTax = 0,
  });

  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'qty',
    required: true,
    includeIfNull: false,
  )


  final num qty;



  @JsonKey(
    
    name: r'unit_price',
    required: true,
    includeIfNull: false,
  )


  final num unitPrice;



  @JsonKey(
    
    name: r'line_total',
    required: true,
    includeIfNull: false,
  )


  final num lineTotal;



  @JsonKey(
    defaultValue: 0,
    name: r'gst_rate',
    required: false,
    includeIfNull: false,
  )


  final num? gstRate;



  @JsonKey(
    defaultValue: 0,
    name: r'gst_amount',
    required: false,
    includeIfNull: false,
  )


  final num? gstAmount;



  @JsonKey(
    defaultValue: 0,
    name: r'price_incl_tax',
    required: false,
    includeIfNull: false,
  )


  final num? priceInclTax;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OrderItemOut &&
      other.productId == productId &&
      other.qty == qty &&
      other.unitPrice == unitPrice &&
      other.lineTotal == lineTotal &&
      other.gstRate == gstRate &&
      other.gstAmount == gstAmount &&
      other.priceInclTax == priceInclTax;

    @override
    int get hashCode =>
        productId.hashCode +
        qty.hashCode +
        unitPrice.hashCode +
        lineTotal.hashCode +
        gstRate.hashCode +
        gstAmount.hashCode +
        priceInclTax.hashCode;

  factory OrderItemOut.fromJson(Map<String, dynamic> json) => _$OrderItemOutFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

