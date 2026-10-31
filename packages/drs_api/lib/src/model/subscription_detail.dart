//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/subscription_item_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_detail.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscriptionDetail {
  /// Returns a new [SubscriptionDetail] instance.
  SubscriptionDetail({

    required  this.id,

    required  this.shopId,

    required  this.accountId,

    required  this.status,

    required  this.startDate,

     this.endDate,

     this.items,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'shop_id',
    required: true,
    includeIfNull: false,
  )


  final int shopId;



  @JsonKey(
    
    name: r'account_id',
    required: true,
    includeIfNull: false,
  )


  final int accountId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'start_date',
    required: true,
    includeIfNull: false,
  )


  final DateTime startDate;



  @JsonKey(
    
    name: r'end_date',
    required: false,
    includeIfNull: false,
  )


  final DateTime? endDate;



  @JsonKey(
    
    name: r'items',
    required: false,
    includeIfNull: false,
  )


  final List<SubscriptionItemOut>? items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SubscriptionDetail &&
      other.id == id &&
      other.shopId == shopId &&
      other.accountId == accountId &&
      other.status == status &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.items == items;

    @override
    int get hashCode =>
        id.hashCode +
        shopId.hashCode +
        accountId.hashCode +
        status.hashCode +
        startDate.hashCode +
        endDate.hashCode +
        items.hashCode;

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) => _$SubscriptionDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

