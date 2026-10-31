//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/deliver_item.dart';
import 'package:drs_api/src/model/podin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deliver_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeliverRequest {
  /// Returns a new [DeliverRequest] instance.
  DeliverRequest({

    required  this.items,

     this.pod,

     this.cashCollected,

     this.cashMethod,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<DeliverItem> items;



  @JsonKey(
    
    name: r'pod',
    required: false,
    includeIfNull: false,
  )


  final PODIn? pod;



          // minimum: 0
  @JsonKey(
    
    name: r'cash_collected',
    required: false,
    includeIfNull: false,
  )


  final num? cashCollected;



      /// cash | upi | cheque
  @JsonKey(
    
    name: r'cash_method',
    required: false,
    includeIfNull: false,
  )


  final String? cashMethod;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeliverRequest &&
      other.items == items &&
      other.pod == pod &&
      other.cashCollected == cashCollected &&
      other.cashMethod == cashMethod;

    @override
    int get hashCode =>
        items.hashCode +
        pod.hashCode +
        cashCollected.hashCode +
        cashMethod.hashCode;

  factory DeliverRequest.fromJson(Map<String, dynamic> json) => _$DeliverRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

