//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'wallet_txn_line_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WalletTxnLineOut {
  /// Returns a new [WalletTxnLineOut] instance.
  WalletTxnLineOut({

    required  this.id,

    required  this.txnType,

    required  this.amount,

    required  this.balanceAfter,

    required  this.createdAt,

     this.refType,

     this.refId,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'txn_type',
    required: true,
    includeIfNull: false,
  )


  final String txnType;



      /// Signed: + credit, - debit
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



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'ref_type',
    required: false,
    includeIfNull: false,
  )


  final String? refType;



  @JsonKey(
    
    name: r'ref_id',
    required: false,
    includeIfNull: false,
  )


  final int? refId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WalletTxnLineOut &&
      other.id == id &&
      other.txnType == txnType &&
      other.amount == amount &&
      other.balanceAfter == balanceAfter &&
      other.createdAt == createdAt &&
      other.refType == refType &&
      other.refId == refId;

    @override
    int get hashCode =>
        id.hashCode +
        txnType.hashCode +
        amount.hashCode +
        balanceAfter.hashCode +
        createdAt.hashCode +
        refType.hashCode +
        refId.hashCode;

  factory WalletTxnLineOut.fromJson(Map<String, dynamic> json) => _$WalletTxnLineOutFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTxnLineOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

