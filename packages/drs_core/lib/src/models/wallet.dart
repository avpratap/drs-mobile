import 'package:meta/meta.dart';

import 'money.dart';

@immutable
class WalletSummary {
  const WalletSummary({
    required this.balance,
    required this.creditOutstanding,
    required this.billingMode,
  });

  final Money balance;
  final Money creditOutstanding;

  /// e.g. `prepaid_wallet`, `credit`.
  final String billingMode;

  bool get isPrepaid => billingMode.startsWith('prepaid');
}

/// One wallet-ledger line. [amount] is signed: + credit, − debit.
@immutable
class WalletTxn {
  const WalletTxn({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.createdAt,
    this.refType,
  });

  final int id;
  final String type;
  final Money amount;
  final Money balanceAfter;
  final DateTime createdAt;
  final String? refType;

  bool get isCredit => !amount.isNegative;

  String get label {
    final t = type.replaceAll('_', ' ').trim();
    return t.isEmpty ? 'Transaction' : '${t[0].toUpperCase()}${t.substring(1)}';
  }
}
