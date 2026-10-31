//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/variant_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_full_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProductFullOut {
  /// Returns a new [ProductFullOut] instance.
  ProductFullOut({

    required  this.id,

    required  this.sku,

    required  this.name,

    required  this.status,

     this.description,

     this.uom = 'piece',

     this.packSize = 1,

     this.isSubscribable = true,

     this.perishable = true,

     this.gstRate = 0,

     this.category,

     this.imageUrl,

     this.fromPrice,

     this.avgRating = 0,

     this.ratingCount = 0,

     this.variants,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'sku',
    required: true,
    includeIfNull: false,
  )


  final String sku;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    defaultValue: 'piece',
    name: r'uom',
    required: false,
    includeIfNull: false,
  )


  final String? uom;



  @JsonKey(
    defaultValue: 1,
    name: r'pack_size',
    required: false,
    includeIfNull: false,
  )


  final num? packSize;



  @JsonKey(
    defaultValue: true,
    name: r'is_subscribable',
    required: false,
    includeIfNull: false,
  )


  final bool? isSubscribable;



  @JsonKey(
    defaultValue: true,
    name: r'perishable',
    required: false,
    includeIfNull: false,
  )


  final bool? perishable;



  @JsonKey(
    defaultValue: 0,
    name: r'gst_rate',
    required: false,
    includeIfNull: false,
  )


  final num? gstRate;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final String? category;



  @JsonKey(
    
    name: r'image_url',
    required: false,
    includeIfNull: false,
  )


  final String? imageUrl;



  @JsonKey(
    
    name: r'from_price',
    required: false,
    includeIfNull: false,
  )


  final num? fromPrice;



  @JsonKey(
    defaultValue: 0,
    name: r'avg_rating',
    required: false,
    includeIfNull: false,
  )


  final num? avgRating;



  @JsonKey(
    defaultValue: 0,
    name: r'rating_count',
    required: false,
    includeIfNull: false,
  )


  final int? ratingCount;



  @JsonKey(
    
    name: r'variants',
    required: false,
    includeIfNull: false,
  )


  final List<VariantOut>? variants;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProductFullOut &&
      other.id == id &&
      other.sku == sku &&
      other.name == name &&
      other.status == status &&
      other.description == description &&
      other.uom == uom &&
      other.packSize == packSize &&
      other.isSubscribable == isSubscribable &&
      other.perishable == perishable &&
      other.gstRate == gstRate &&
      other.category == category &&
      other.imageUrl == imageUrl &&
      other.fromPrice == fromPrice &&
      other.avgRating == avgRating &&
      other.ratingCount == ratingCount &&
      other.variants == variants;

    @override
    int get hashCode =>
        id.hashCode +
        sku.hashCode +
        name.hashCode +
        status.hashCode +
        description.hashCode +
        uom.hashCode +
        packSize.hashCode +
        isSubscribable.hashCode +
        perishable.hashCode +
        gstRate.hashCode +
        category.hashCode +
        imageUrl.hashCode +
        fromPrice.hashCode +
        avgRating.hashCode +
        ratingCount.hashCode +
        variants.hashCode;

  factory ProductFullOut.fromJson(Map<String, dynamic> json) => _$ProductFullOutFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFullOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

