// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_txn_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTxnOut _$WalletTxnOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WalletTxnOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['txn_type', 'amount', 'balance_after']);
  final val = WalletTxnOut(
    txnType: $checkedConvert('txn_type', (v) => v as String),
    amount: $checkedConvert('amount', (v) => v as num),
    balanceAfter: $checkedConvert('balance_after', (v) => v as num),
  );
  return val;
}, fieldKeyMap: const {'txnType': 'txn_type', 'balanceAfter': 'balance_after'});

Map<String, dynamic> _$WalletTxnOutToJson(WalletTxnOut instance) =>
    <String, dynamic>{
      'txn_type': instance.txnType,
      'amount': instance.amount,
      'balance_after': instance.balanceAfter,
    };
