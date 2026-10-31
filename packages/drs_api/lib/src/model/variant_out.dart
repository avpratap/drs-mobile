//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'variant_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VariantOut {
  /// Returns a new [VariantOut] instance.
  VariantOut({

    required  this.id,

    required  this.productId,

    required  this.sku,

    required  this.label,

    required  this.packSize,

    required  this.price,

    required  this.status,

    required  this.sortOrder,

     this.mrp,

     this.imageUrl,

     this.sellingPrice,

     this.priceAvailable,

     this.showMrpStrike = false,
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
    
    name: r'sku',
    required: true,
    includeIfNull: false,
  )


  final String sku;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



      /// Cart qty for one pack, in the product uom
  @JsonKey(
    
    name: r'pack_size',
    required: true,
    includeIfNull: false,
  )


  final num packSize;



      /// Legacy catalogue field — do NOT display; use selling_price
  @JsonKey(
    
    name: r'price',
    required: true,
    includeIfNull: false,
  )


  final num price;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'sort_order',
    required: true,
    includeIfNull: false,
  )


  final int sortOrder;



  @JsonKey(
    
    name: r'mrp',
    required: false,
    includeIfNull: false,
  )


  final num? mrp;



  @JsonKey(
    
    name: r'image_url',
    required: false,
    includeIfNull: false,
  )


  final String? imageUrl;



      /// GST-inclusive storefront price of this pack
  @JsonKey(
    
    name: r'selling_price',
    required: false,
    includeIfNull: false,
  )


  final num? sellingPrice;



  @JsonKey(
    
    name: r'price_available',
    required: false,
    includeIfNull: false,
  )


  final bool? priceAvailable;



  @JsonKey(
    defaultValue: false,
    name: r'show_mrp_strike',
    required: false,
    includeIfNull: false,
  )


  final bool? showMrpStrike;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VariantOut &&
      other.id == id &&
      other.productId == productId &&
      other.sku == sku &&
      other.label == label &&
      other.packSize == packSize &&
      other.price == price &&
      other.status == status &&
      other.sortOrder == sortOrder &&
      other.mrp == mrp &&
      other.imageUrl == imageUrl &&
      other.sellingPrice == sellingPrice &&
      other.priceAvailable == priceAvailable &&
      other.showMrpStrike == showMrpStrike;

    @override
    int get hashCode =>
        id.hashCode +
        productId.hashCode +
        sku.hashCode +
        label.hashCode +
        packSize.hashCode +
        price.hashCode +
        status.hashCode +
        sortOrder.hashCode +
        mrp.hashCode +
        imageUrl.hashCode +
        sellingPrice.hashCode +
        priceAvailable.hashCode +
        showMrpStrike.hashCode;

  factory VariantOut.fromJson(Map<String, dynamic> json) => _$VariantOutFromJson(json);

  Map<String, dynamic> toJson() => _$VariantOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

