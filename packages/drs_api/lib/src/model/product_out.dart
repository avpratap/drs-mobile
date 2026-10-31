//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'product_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProductOut {
  /// Returns a new [ProductOut] instance.
  ProductOut({

    required  this.id,

    required  this.sku,

    required  this.name,

    required  this.status,

     this.description,

     this.uom = 'piece',

     this.packSize = 1,

     this.isSubscribable = true,

     this.perishable = true,

     this.hsnCode,

     this.gstRate = 0,

     this.category,

     this.imageUrl,

     this.fromPrice,

     this.avgRating = 0,

     this.ratingCount = 0,

     this.weightKg,

     this.lengthCm,

     this.widthCm,

     this.heightCm,
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
    
    name: r'hsn_code',
    required: false,
    includeIfNull: false,
  )


  final String? hsnCode;



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



      /// Lowest GST-inclusive retail price (INR)
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
    
    name: r'weight_kg',
    required: false,
    includeIfNull: false,
  )


  final num? weightKg;



  @JsonKey(
    
    name: r'length_cm',
    required: false,
    includeIfNull: false,
  )


  final num? lengthCm;



  @JsonKey(
    
    name: r'width_cm',
    required: false,
    includeIfNull: false,
  )


  final num? widthCm;



  @JsonKey(
    
    name: r'height_cm',
    required: false,
    includeIfNull: false,
  )


  final num? heightCm;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProductOut &&
      other.id == id &&
      other.sku == sku &&
      other.name == name &&
      other.status == status &&
      other.description == description &&
      other.uom == uom &&
      other.packSize == packSize &&
      other.isSubscribable == isSubscribable &&
      other.perishable == perishable &&
      other.hsnCode == hsnCode &&
      other.gstRate == gstRate &&
      other.category == category &&
      other.imageUrl == imageUrl &&
      other.fromPrice == fromPrice &&
      other.avgRating == avgRating &&
      other.ratingCount == ratingCount &&
      other.weightKg == weightKg &&
      other.lengthCm == lengthCm &&
      other.widthCm == widthCm &&
      other.heightCm == heightCm;

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
        hsnCode.hashCode +
        gstRate.hashCode +
        category.hashCode +
        imageUrl.hashCode +
        fromPrice.hashCode +
        avgRating.hashCode +
        ratingCount.hashCode +
        weightKg.hashCode +
        lengthCm.hashCode +
        widthCm.hashCode +
        heightCm.hashCode;

  factory ProductOut.fromJson(Map<String, dynamic> json) => _$ProductOutFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

