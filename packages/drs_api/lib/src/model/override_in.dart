//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'override_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OverrideIn {
  /// Returns a new [OverrideIn] instance.
  OverrideIn({

    required  this.productId,

    required  this.forDate,

    required  this.overrideQty,

     this.note,
  });

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


  final DateTime forDate;



      /// 0 = skip that day
          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'override_qty',
    required: true,
    includeIfNull: false,
  )


  final num overrideQty;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OverrideIn &&
      other.productId == productId &&
      other.forDate == forDate &&
      other.overrideQty == overrideQty &&
      other.note == note;

    @override
    int get hashCode =>
        productId.hashCode +
        forDate.hashCode +
        overrideQty.hashCode +
        note.hashCode;

  factory OverrideIn.fromJson(Map<String, dynamic> json) => _$OverrideInFromJson(json);

  Map<String, dynamic> toJson() => _$OverrideInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

