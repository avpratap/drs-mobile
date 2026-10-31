//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscription_item_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionItemOut {
  /// Returns a new [SubscriptionItemOut] instance.
  SubscriptionItemOut({

    required  this.id,

    required  this.productId,

    required  this.defaultQty,

    required  this.active,

     this.frequency = 'daily',

     this.intervalDays,

     this.daysOfWeek,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'default_qty',
    required: true,
    includeIfNull: false,
  )


  final num defaultQty;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    defaultValue: 'daily',
    name: r'frequency',
    required: false,
    includeIfNull: false,
  )


  final String? frequency;



  @JsonKey(
    
    name: r'interval_days',
    required: false,
    includeIfNull: false,
  )


  final int? intervalDays;



  @JsonKey(
    
    name: r'days_of_week',
    required: false,
    includeIfNull: false,
  )


  final String? daysOfWeek;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SubscriptionItemOut &&
      other.id == id &&
      other.productId == productId &&
      other.defaultQty == defaultQty &&
      other.active == active &&
      other.frequency == frequency &&
      other.intervalDays == intervalDays &&
      other.daysOfWeek == daysOfWeek;

    @override
    int get hashCode =>
        id.hashCode +
        productId.hashCode +
        defaultQty.hashCode +
        active.hashCode +
        frequency.hashCode +
        intervalDays.hashCode +
        daysOfWeek.hashCode;

  factory SubscriptionItemOut.fromJson(Map<String, dynamic> json) => _$SubscriptionItemOutFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionItemOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

