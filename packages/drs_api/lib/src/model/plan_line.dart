//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'plan_line.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PlanLine {
  /// Returns a new [PlanLine] instance.
  PlanLine({

    required  this.productId,

    required  this.qty,
  });

  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'qty',
    required: true,
    includeIfNull: false,
  )


  final num qty;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PlanLine &&
      other.productId == productId &&
      other.qty == qty;

    @override
    int get hashCode =>
        productId.hashCode +
        qty.hashCode;

  factory PlanLine.fromJson(Map<String, dynamic> json) => _$PlanLineFromJson(json);

  Map<String, dynamic> toJson() => _$PlanLineToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

