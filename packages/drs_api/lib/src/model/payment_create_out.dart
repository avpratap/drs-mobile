//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'payment_create_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentCreateOut {
  /// Returns a new [PaymentCreateOut] instance.
  PaymentCreateOut({

    required  this.paymentId,

    required  this.gatewayOrderId,

    required  this.amount,

    required  this.keyId,
  });

  @JsonKey(
    
    name: r'payment_id',
    required: true,
    includeIfNull: false,
  )


  final int paymentId;



  @JsonKey(
    
    name: r'gateway_order_id',
    required: true,
    includeIfNull: false,
  )


  final String gatewayOrderId;



  @JsonKey(
    
    name: r'amount',
    required: true,
    includeIfNull: false,
  )


  final num amount;



      /// Razorpay publishable key id (\"\" in dev stub)
  @JsonKey(
    
    name: r'key_id',
    required: true,
    includeIfNull: false,
  )


  final String keyId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentCreateOut &&
      other.paymentId == paymentId &&
      other.gatewayOrderId == gatewayOrderId &&
      other.amount == amount &&
      other.keyId == keyId;

    @override
    int get hashCode =>
        paymentId.hashCode +
        gatewayOrderId.hashCode +
        amount.hashCode +
        keyId.hashCode;

  factory PaymentCreateOut.fromJson(Map<String, dynamic> json) => _$PaymentCreateOutFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCreateOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

