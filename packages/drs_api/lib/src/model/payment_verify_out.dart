//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'payment_verify_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentVerifyOut {
  /// Returns a new [PaymentVerifyOut] instance.
  PaymentVerifyOut({

    required  this.detail,

    required  this.paymentId,

    required  this.status,
  });

  @JsonKey(
    
    name: r'detail',
    required: true,
    includeIfNull: false,
  )


  final String detail;



  @JsonKey(
    
    name: r'payment_id',
    required: true,
    includeIfNull: false,
  )


  final int paymentId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentVerifyOut &&
      other.detail == detail &&
      other.paymentId == paymentId &&
      other.status == status;

    @override
    int get hashCode =>
        detail.hashCode +
        paymentId.hashCode +
        status.hashCode;

  factory PaymentVerifyOut.fromJson(Map<String, dynamic> json) => _$PaymentVerifyOutFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentVerifyOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

