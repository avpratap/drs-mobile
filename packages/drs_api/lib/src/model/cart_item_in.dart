//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'cart_item_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CartItemIn {
  /// Returns a new [CartItemIn] instance.
  CartItemIn({

    required  this.productId,

    required  this.qty,
  });

  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'qty',
    required: true,
    includeIfNull: false,
  )


  final num qty;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CartItemIn &&
      other.productId == productId &&
      other.qty == qty;

    @override
    int get hashCode =>
        productId.hashCode +
        qty.hashCode;

  factory CartItemIn.fromJson(Map<String, dynamic> json) => _$CartItemInFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

