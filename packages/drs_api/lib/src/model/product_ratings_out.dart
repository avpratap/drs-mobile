//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/rating_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_ratings_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProductRatingsOut {
  /// Returns a new [ProductRatingsOut] instance.
  ProductRatingsOut({

    required  this.productId,

    required  this.count,

    required  this.average,

    required  this.distribution,

    required  this.ratings,
  });

  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;



  @JsonKey(
    
    name: r'average',
    required: true,
    includeIfNull: false,
  )


  final num average;



      /// stars (\"1\"..\"5\") -> count of approved reviews
  @JsonKey(
    
    name: r'distribution',
    required: true,
    includeIfNull: false,
  )


  final Map<String, int> distribution;



  @JsonKey(
    
    name: r'ratings',
    required: true,
    includeIfNull: false,
  )


  final List<RatingOut> ratings;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProductRatingsOut &&
      other.productId == productId &&
      other.count == count &&
      other.average == average &&
      other.distribution == distribution &&
      other.ratings == ratings;

    @override
    int get hashCode =>
        productId.hashCode +
        count.hashCode +
        average.hashCode +
        distribution.hashCode +
        ratings.hashCode;

  factory ProductRatingsOut.fromJson(Map<String, dynamic> json) => _$ProductRatingsOutFromJson(json);

  Map<String, dynamic> toJson() => _$ProductRatingsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

