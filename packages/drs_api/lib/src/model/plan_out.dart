//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/plan_line.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PlanOut {
  /// Returns a new [PlanOut] instance.
  PlanOut({

    required  this.forDate,

    required  this.lines,
  });

  @JsonKey(
    
    name: r'for_date',
    required: true,
    includeIfNull: false,
  )


  final DateTime forDate;



  @JsonKey(
    
    name: r'lines',
    required: true,
    includeIfNull: false,
  )


  final List<PlanLine> lines;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PlanOut &&
      other.forDate == forDate &&
      other.lines == lines;

    @override
    int get hashCode =>
        forDate.hashCode +
        lines.hashCode;

  factory PlanOut.fromJson(Map<String, dynamic> json) => _$PlanOutFromJson(json);

  Map<String, dynamic> toJson() => _$PlanOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

