//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'wallet_txn_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WalletTxnOut {
  /// Returns a new [WalletTxnOut] instance.
  WalletTxnOut({

    required  this.txnType,

    required  this.amount,

    required  this.balanceAfter,
  });

  @JsonKey(
    
    name: r'txn_type',
    required: true,
    includeIfNull: false,
  )


  final String txnType;



  @JsonKey(
    
    name: r'amount',
    required: true,
    includeIfNull: false,
  )


  final num amount;



  @JsonKey(
    
    name: r'balance_after',
    required: true,
    includeIfNull: false,
  )


  final num balanceAfter;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WalletTxnOut &&
      other.txnType == txnType &&
      other.amount == amount &&
      other.balanceAfter == balanceAfter;

    @override
    int get hashCode =>
        txnType.hashCode +
        amount.hashCode +
        balanceAfter.hashCode;

  factory WalletTxnOut.fromJson(Map<String, dynamic> json) => _$WalletTxnOutFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTxnOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

