//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'quote_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuoteIn {
  /// Returns a new [QuoteIn] instance.
  QuoteIn({

     this.couponCode,

     this.pincode,

     this.weightKg = 0.5,

     this.cod = false,
  });

  @JsonKey(
    
    name: r'coupon_code',
    required: false,
    includeIfNull: false,
  )


  final String? couponCode;



  @JsonKey(
    
    name: r'pincode',
    required: false,
    includeIfNull: false,
  )


  final String? pincode;



  @JsonKey(
    defaultValue: 0.5,
    name: r'weight_kg',
    required: false,
    includeIfNull: false,
  )


  final num? weightKg;



  @JsonKey(
    defaultValue: false,
    name: r'cod',
    required: false,
    includeIfNull: false,
  )


  final bool? cod;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuoteIn &&
      other.couponCode == couponCode &&
      other.pincode == pincode &&
      other.weightKg == weightKg &&
      other.cod == cod;

    @override
    int get hashCode =>
        couponCode.hashCode +
        pincode.hashCode +
        weightKg.hashCode +
        cod.hashCode;

  factory QuoteIn.fromJson(Map<String, dynamic> json) => _$QuoteInFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

