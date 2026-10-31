//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'delivery_summary_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeliverySummaryOut {
  /// Returns a new [DeliverySummaryOut] instance.
  DeliverySummaryOut({

    required  this.date,

    required  this.delivered,

    required  this.failed,

    required  this.pending,

    required  this.cashCollected,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



  @JsonKey(
    
    name: r'delivered',
    required: true,
    includeIfNull: false,
  )


  final int delivered;



  @JsonKey(
    
    name: r'failed',
    required: true,
    includeIfNull: false,
  )


  final int failed;



  @JsonKey(
    
    name: r'pending',
    required: true,
    includeIfNull: false,
  )


  final int pending;



  @JsonKey(
    
    name: r'cash_collected',
    required: true,
    includeIfNull: false,
  )


  final num cashCollected;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeliverySummaryOut &&
      other.date == date &&
      other.delivered == delivered &&
      other.failed == failed &&
      other.pending == pending &&
      other.cashCollected == cashCollected;

    @override
    int get hashCode =>
        date.hashCode +
        delivered.hashCode +
        failed.hashCode +
        pending.hashCode +
        cashCollected.hashCode;

  factory DeliverySummaryOut.fromJson(Map<String, dynamic> json) => _$DeliverySummaryOutFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverySummaryOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

