//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/shipment_track_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_tracking_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderTrackingOut {
  /// Returns a new [OrderTrackingOut] instance.
  OrderTrackingOut({

    required  this.orderId,

    required  this.orderNo,

    required  this.status,

    required  this.paymentStatus,

     this.shipments,
  });

  @JsonKey(
    
    name: r'order_id',
    required: true,
    includeIfNull: false,
  )


  final int orderId;



  @JsonKey(
    
    name: r'order_no',
    required: true,
    includeIfNull: false,
  )


  final String orderNo;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'payment_status',
    required: true,
    includeIfNull: false,
  )


  final String paymentStatus;



  @JsonKey(
    
    name: r'shipments',
    required: false,
    includeIfNull: false,
  )


  final List<ShipmentTrackOut>? shipments;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OrderTrackingOut &&
      other.orderId == orderId &&
      other.orderNo == orderNo &&
      other.status == status &&
      other.paymentStatus == paymentStatus &&
      other.shipments == shipments;

    @override
    int get hashCode =>
        orderId.hashCode +
        orderNo.hashCode +
        status.hashCode +
        paymentStatus.hashCode +
        shipments.hashCode;

  factory OrderTrackingOut.fromJson(Map<String, dynamic> json) => _$OrderTrackingOutFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTrackingOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

