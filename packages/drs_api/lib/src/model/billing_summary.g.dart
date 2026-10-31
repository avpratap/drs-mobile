// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingSummary _$BillingSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BillingSummary',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'account_id',
            'billing_mode',
            'wallet_balance',
            'credit_outstanding',
          ],
        );
        final val = BillingSummary(
          accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
          billingMode: $checkedConvert('billing_mode', (v) => v as String),
          walletBalance: $checkedConvert('wallet_balance', (v) => v as num),
          creditOutstanding: $checkedConvert(
            'credit_outstanding',
            (v) => v as num,
          ),
          recentWalletTxns: $checkedConvert(
            'recent_wallet_txns',
            (v) => (v as List<dynamic>?)
                ?.map((e) => WalletTxnOut.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'accountId': 'account_id',
        'billingMode': 'billing_mode',
        'walletBalance': 'wallet_balance',
        'creditOutstanding': 'credit_outstanding',
        'recentWalletTxns': 'recent_wallet_txns',
      },
    );

Map<String, dynamic> _$BillingSummaryToJson(BillingSummary instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'billing_mode': instance.billingMode,
      'wallet_balance': instance.walletBalance,
      'credit_outstanding': instance.creditOutstanding,
      'recent_wallet_txns': ?instance.recentWalletTxns
          ?.map((e) => e.toJson())
          .toList(),
    };
