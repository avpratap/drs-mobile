//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'cart_line_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CartLineOut {
  /// Returns a new [CartLineOut] instance.
  CartLineOut({

    required  this.id,

    required  this.productId,

    required  this.qty,

    required  this.unitPrice,

    required  this.lineTotal,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is CartLineOut &&
      other.id == id &&
      other.productId == productId &&
      other.qty == qty &&
      other.unitPrice == unitPrice &&
      other.lineTotal == lineTotal;

    @override
    int get hashCode =>
        id.hashCode +
        productId.hashCode +
        qty.hashCode +
        unitPrice.hashCode +
        lineTotal.hashCode;

  factory CartLineOut.fromJson(Map<String, dynamic> json) => _$CartLineOutFromJson(json);

  Map<String, dynamic> toJson() => _$CartLineOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

