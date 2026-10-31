//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/delivery_order_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_stop_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RouteStopOut {
  /// Returns a new [RouteStopOut] instance.
  RouteStopOut({

    required  this.sequence,

    required  this.order,
  });

  @JsonKey(
    
    name: r'sequence',
    required: true,
    includeIfNull: false,
  )


  final int sequence;



  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final DeliveryOrderOut order;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RouteStopOut &&
      other.sequence == sequence &&
      other.order == order;

    @override
    int get hashCode =>
        sequence.hashCode +
        order.hashCode;

  factory RouteStopOut.fromJson(Map<String, dynamic> json) => _$RouteStopOutFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStopOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

