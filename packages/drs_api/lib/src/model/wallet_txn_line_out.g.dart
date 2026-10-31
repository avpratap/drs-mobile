// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_txn_line_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTxnLineOut _$WalletTxnLineOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WalletTxnLineOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'txn_type',
            'amount',
            'balance_after',
            'created_at',
          ],
        );
        final val = WalletTxnLineOut(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          txnType: $checkedConvert('txn_type', (v) => v as String),
          amount: $checkedConvert('amount', (v) => v as num),
          balanceAfter: $checkedConvert('balance_after', (v) => v as num),
          createdAt: $checkedConvert(
            'created_at',
            (v) => DateTime.parse(v as String),
          ),
          refType: $checkedConvert('ref_type', (v) => v as String?),
          refId: $checkedConvert('ref_id', (v) => (v as num?)?.toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'txnType': 'txn_type',
        'balanceAfter': 'balance_after',
        'createdAt': 'created_at',
        'refType': 'ref_type',
        'refId': 'ref_id',
      },
    );

Map<String, dynamic> _$WalletTxnLineOutToJson(WalletTxnLineOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'txn_type': instance.txnType,
      'amount': instance.amount,
      'balance_after': instance.balanceAfter,
      'created_at': instance.createdAt.toIso8601String(),
      'ref_type': ?instance.refType,
      'ref_id': ?instance.refId,
    };
