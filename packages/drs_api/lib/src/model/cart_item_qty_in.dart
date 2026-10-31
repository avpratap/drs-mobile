//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'cart_item_qty_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CartItemQtyIn {
  /// Returns a new [CartItemQtyIn] instance.
  CartItemQtyIn({

    required  this.qty,
  });

          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'qty',
    required: true,
    includeIfNull: false,
  )


  final num qty;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CartItemQtyIn &&
      other.qty == qty;

    @override
    int get hashCode =>
        qty.hashCode;

  factory CartItemQtyIn.fromJson(Map<String, dynamic> json) => _$CartItemQtyInFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemQtyInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

