//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/quote_line_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuoteOut {
  /// Returns a new [QuoteOut] instance.
  QuoteOut({

    required  this.subtotal,

    required  this.discount,

    required  this.taxTotal,

    required  this.total,

    required  this.totalInclTax,

     this.items,

     this.serviceable,

     this.etdDays,

     this.shippingRate,
  });

  @JsonKey(
    
    name: r'subtotal',
    required: true,
    includeIfNull: false,
  )


  final num subtotal;



  @JsonKey(
    
    name: r'discount',
    required: true,
    includeIfNull: false,
  )


  final num discount;



  @JsonKey(
    
    name: r'tax_total',
    required: true,
    includeIfNull: false,
  )


  final num taxTotal;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final num total;



  @JsonKey(
    
    name: r'total_incl_tax',
    required: true,
    includeIfNull: false,
  )


  final num totalInclTax;



  @JsonKey(
    
    name: r'items',
    required: false,
    includeIfNull: false,
  )


  final List<QuoteLineOut>? items;



  @JsonKey(
    
    name: r'serviceable',
    required: false,
    includeIfNull: false,
  )


  final bool? serviceable;



  @JsonKey(
    
    name: r'etd_days',
    required: false,
    includeIfNull: false,
  )


  final int? etdDays;



  @JsonKey(
    
    name: r'shipping_rate',
    required: false,
    includeIfNull: false,
  )


  final num? shippingRate;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuoteOut &&
      other.subtotal == subtotal &&
      other.discount == discount &&
      other.taxTotal == taxTotal &&
      other.total == total &&
      other.totalInclTax == totalInclTax &&
      other.items == items &&
      other.serviceable == serviceable &&
      other.etdDays == etdDays &&
      other.shippingRate == shippingRate;

    @override
    int get hashCode =>
        subtotal.hashCode +
        discount.hashCode +
        taxTotal.hashCode +
        total.hashCode +
        totalInclTax.hashCode +
        items.hashCode +
        serviceable.hashCode +
        etdDays.hashCode +
        shippingRate.hashCode;

  factory QuoteOut.fromJson(Map<String, dynamic> json) => _$QuoteOutFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

