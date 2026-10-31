//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'payment_create.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentCreate {
  /// Returns a new [PaymentCreate] instance.
  PaymentCreate({

    required  this.purpose,

     this.amount,

     this.orderId,
  });

      /// wallet_topup | order_payment
  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final String purpose;



      /// Required for wallet_topup; ignored for order_payment
  @JsonKey(
    
    name: r'amount',
    required: false,
    includeIfNull: false,
  )


  final num? amount;



  @JsonKey(
    
    name: r'order_id',
    required: false,
    includeIfNull: false,
  )


  final int? orderId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentCreate &&
      other.purpose == purpose &&
      other.amount == amount &&
      other.orderId == orderId;

    @override
    int get hashCode =>
        purpose.hashCode +
        amount.hashCode +
        orderId.hashCode;

  factory PaymentCreate.fromJson(Map<String, dynamic> json) => _$PaymentCreateFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

