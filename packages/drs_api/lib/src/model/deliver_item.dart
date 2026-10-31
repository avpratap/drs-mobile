//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'deliver_item.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeliverItem {
  /// Returns a new [DeliverItem] instance.
  DeliverItem({

    required  this.productId,

    required  this.qtyDelivered,
  });

  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'qty_delivered',
    required: true,
    includeIfNull: false,
  )


  final num qtyDelivered;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeliverItem &&
      other.productId == productId &&
      other.qtyDelivered == qtyDelivered;

    @override
    int get hashCode =>
        productId.hashCode +
        qtyDelivered.hashCode;

  factory DeliverItem.fromJson(Map<String, dynamic> json) => _$DeliverItemFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

