//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'quote_line_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuoteLineOut {
  /// Returns a new [QuoteLineOut] instance.
  QuoteLineOut({

    required  this.productId,

    required  this.qty,

    required  this.unitPrice,

    required  this.lineTotal,

    required  this.gstRate,

    required  this.gstAmount,
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
    
    name: r'gst_rate',
    required: true,
    includeIfNull: false,
  )


  final num gstRate;



  @JsonKey(
    
    name: r'gst_amount',
    required: true,
    includeIfNull: false,
  )


  final num gstAmount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuoteLineOut &&
      other.productId == productId &&
      other.qty == qty &&
      other.unitPrice == unitPrice &&
      other.lineTotal == lineTotal &&
      other.gstRate == gstRate &&
      other.gstAmount == gstAmount;

    @override
    int get hashCode =>
        productId.hashCode +
        qty.hashCode +
        unitPrice.hashCode +
        lineTotal.hashCode +
        gstRate.hashCode +
        gstAmount.hashCode;

  factory QuoteLineOut.fromJson(Map<String, dynamic> json) => _$QuoteLineOutFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteLineOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

