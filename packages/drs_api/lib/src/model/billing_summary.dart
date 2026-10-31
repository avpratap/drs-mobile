//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:drs_api/src/model/wallet_txn_out.dart';
import 'package:json_annotation/json_annotation.dart';

part 'billing_summary.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BillingSummary {
  /// Returns a new [BillingSummary] instance.
  BillingSummary({

    required  this.accountId,

    required  this.billingMode,

    required  this.walletBalance,

    required  this.creditOutstanding,

     this.recentWalletTxns,
  });

  @JsonKey(
    
    name: r'account_id',
    required: true,
    includeIfNull: false,
  )


  final int accountId;



  @JsonKey(
    
    name: r'billing_mode',
    required: true,
    includeIfNull: false,
  )


  final String billingMode;



  @JsonKey(
    
    name: r'wallet_balance',
    required: true,
    includeIfNull: false,
  )


  final num walletBalance;



  @JsonKey(
    
    name: r'credit_outstanding',
    required: true,
    includeIfNull: false,
  )


  final num creditOutstanding;



  @JsonKey(
    
    name: r'recent_wallet_txns',
    required: false,
    includeIfNull: false,
  )


  final List<WalletTxnOut>? recentWalletTxns;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BillingSummary &&
      other.accountId == accountId &&
      other.billingMode == billingMode &&
      other.walletBalance == walletBalance &&
      other.creditOutstanding == creditOutstanding &&
      other.recentWalletTxns == recentWalletTxns;

    @override
    int get hashCode =>
        accountId.hashCode +
        billingMode.hashCode +
        walletBalance.hashCode +
        creditOutstanding.hashCode +
        recentWalletTxns.hashCode;

  factory BillingSummary.fromJson(Map<String, dynamic> json) => _$BillingSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$BillingSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

