//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/tracking_event_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shipment_track_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ShipmentTrackOut {
  /// Returns a new [ShipmentTrackOut] instance.
  ShipmentTrackOut({

    required  this.id,

    required  this.shipmentNo,

    required  this.status,

     this.courier,

     this.awb,

     this.trackingUrl,

     this.events,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'shipment_no',
    required: true,
    includeIfNull: false,
  )


  final String shipmentNo;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'courier',
    required: false,
    includeIfNull: false,
  )


  final String? courier;



  @JsonKey(
    
    name: r'awb',
    required: false,
    includeIfNull: false,
  )


  final String? awb;



  @JsonKey(
    
    name: r'tracking_url',
    required: false,
    includeIfNull: false,
  )


  final String? trackingUrl;



  @JsonKey(
    
    name: r'events',
    required: false,
    includeIfNull: false,
  )


  final List<TrackingEventOut>? events;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ShipmentTrackOut &&
      other.id == id &&
      other.shipmentNo == shipmentNo &&
      other.status == status &&
      other.courier == courier &&
      other.awb == awb &&
      other.trackingUrl == trackingUrl &&
      other.events == events;

    @override
    int get hashCode =>
        id.hashCode +
        shipmentNo.hashCode +
        status.hashCode +
        courier.hashCode +
        awb.hashCode +
        trackingUrl.hashCode +
        events.hashCode;

  factory ShipmentTrackOut.fromJson(Map<String, dynamic> json) => _$ShipmentTrackOutFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentTrackOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

