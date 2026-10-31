//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/cart_line_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CartOut {
  /// Returns a new [CartOut] instance.
  CartOut({

    required  this.id,

    required  this.status,

    required  this.subtotal,

     this.items,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



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
    
    name: r'items',
    required: false,
    includeIfNull: false,
  )


  final List<CartLineOut>? items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CartOut &&
      other.id == id &&
      other.status == status &&
      other.subtotal == subtotal &&
      other.items == items;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        subtotal.hashCode +
        items.hashCode;

  factory CartOut.fromJson(Map<String, dynamic> json) => _$CartOutFromJson(json);

  Map<String, dynamic> toJson() => _$CartOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

