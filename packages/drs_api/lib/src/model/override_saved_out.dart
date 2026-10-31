//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'override_saved_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OverrideSavedOut {
  /// Returns a new [OverrideSavedOut] instance.
  OverrideSavedOut({

    required  this.detail,

    required  this.productId,

    required  this.forDate,

    required  this.qty,
  });

  @JsonKey(
    
    name: r'detail',
    required: true,
    includeIfNull: false,
  )


  final String detail;



  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'for_date',
    required: true,
    includeIfNull: false,
  )


  final String forDate;



  @JsonKey(
    
    name: r'qty',
    required: true,
    includeIfNull: false,
  )


  final num qty;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OverrideSavedOut &&
      other.detail == detail &&
      other.productId == productId &&
      other.forDate == forDate &&
      other.qty == qty;

    @override
    int get hashCode =>
        detail.hashCode +
        productId.hashCode +
        forDate.hashCode +
        qty.hashCode;

  factory OverrideSavedOut.fromJson(Map<String, dynamic> json) => _$OverrideSavedOutFromJson(json);

  Map<String, dynamic> toJson() => _$OverrideSavedOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

