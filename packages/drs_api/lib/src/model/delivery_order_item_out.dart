//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'delivery_order_item_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeliveryOrderItemOut {
  /// Returns a new [DeliveryOrderItemOut] instance.
  DeliveryOrderItemOut({

    required  this.productId,

    required  this.qtyPlanned,

    required  this.qtyDelivered,

    required  this.unitPrice,

    required  this.lineTotal,

    required  this.status,
  });

  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'qty_planned',
    required: true,
    includeIfNull: false,
  )


  final num qtyPlanned;



  @JsonKey(
    
    name: r'qty_delivered',
    required: true,
    includeIfNull: false,
  )


  final num qtyDelivered;



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
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeliveryOrderItemOut &&
      other.productId == productId &&
      other.qtyPlanned == qtyPlanned &&
      other.qtyDelivered == qtyDelivered &&
      other.unitPrice == unitPrice &&
      other.lineTotal == lineTotal &&
      other.status == status;

    @override
    int get hashCode =>
        productId.hashCode +
        qtyPlanned.hashCode +
        qtyDelivered.hashCode +
        unitPrice.hashCode +
        lineTotal.hashCode +
        status.hashCode;

  factory DeliveryOrderItemOut.fromJson(Map<String, dynamic> json) => _$DeliveryOrderItemOutFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOrderItemOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

