//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'payment_verify.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentVerify {
  /// Returns a new [PaymentVerify] instance.
  PaymentVerify({

    required  this.gatewayOrderId,

    required  this.gatewayPaymentId,

    required  this.signature,
  });

  @JsonKey(
    
    name: r'gateway_order_id',
    required: true,
    includeIfNull: false,
  )


  final String gatewayOrderId;



  @JsonKey(
    
    name: r'gateway_payment_id',
    required: true,
    includeIfNull: false,
  )


  final String gatewayPaymentId;



      /// Razorpay signature; \"dev\" in non-prod stub mode
  @JsonKey(
    
    name: r'signature',
    required: true,
    includeIfNull: false,
  )


  final String signature;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentVerify &&
      other.gatewayOrderId == gatewayOrderId &&
      other.gatewayPaymentId == gatewayPaymentId &&
      other.signature == signature;

    @override
    int get hashCode =>
        gatewayOrderId.hashCode +
        gatewayPaymentId.hashCode +
        signature.hashCode;

  factory PaymentVerify.fromJson(Map<String, dynamic> json) => _$PaymentVerifyFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentVerifyToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

