//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_item_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionItemIn {
  /// Returns a new [SubscriptionItemIn] instance.
  SubscriptionItemIn({

    required  this.productId,

    required  this.defaultQty,

     this.frequency = 'daily',

     this.intervalDays,

     this.daysOfWeek,
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
    
    name: r'default_qty',
    required: true,
    includeIfNull: false,
  )


  final num defaultQty;



      /// daily | alternate | weekly
  @JsonKey(
    defaultValue: 'daily',
    name: r'frequency',
    required: false,
    includeIfNull: false,
  )


  final String? frequency;



          // minimum: 1
          // maximum: 365
  @JsonKey(
    
    name: r'interval_days',
    required: false,
    includeIfNull: false,
  )


  final int? intervalDays;



      /// CSV of ISO weekdays, e.g. \"1,3,5\"
  @JsonKey(
    
    name: r'days_of_week',
    required: false,
    includeIfNull: false,
  )


  final String? daysOfWeek;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SubscriptionItemIn &&
      other.productId == productId &&
      other.defaultQty == defaultQty &&
      other.frequency == frequency &&
      other.intervalDays == intervalDays &&
      other.daysOfWeek == daysOfWeek;

    @override
    int get hashCode =>
        productId.hashCode +
        defaultQty.hashCode +
        frequency.hashCode +
        intervalDays.hashCode +
        daysOfWeek.hashCode;

  factory SubscriptionItemIn.fromJson(Map<String, dynamic> json) => _$SubscriptionItemInFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionItemInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

