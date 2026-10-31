import 'package:meta/meta.dart';

import '../utils/pii.dart';
import 'money.dart';

enum AccountRole {
  customer,
  subscriber,
  delivery,
  admin,
  other;

  static AccountRole parse(String raw) => switch (raw.toLowerCase()) {
    'customer' => AccountRole.customer,
    'subscriber' => AccountRole.subscriber,
    'delivery' => AccountRole.delivery,
    'admin' => AccountRole.admin,
    _ => AccountRole.other,
  };
}

/// The signed-in user's account. Holds PII (phone, name): never log the raw
/// object — [toString] is deliberately redacted.
@immutable
class Account {
  const Account({
    required this.userId,
    required this.phone,
    required this.role,
    this.fullName,
    this.walletBalance,
  });

  final int userId;

  /// E.164 phone (`+9198…`). PII.
  final String phone;
  final AccountRole role;

  /// PII.
  final String? fullName;

  /// Null until billing has been fetched.
  final Money? walletBalance;

  String get maskedPhone => Pii.maskPhone(phone);

  String get greetingName {
    final n = fullName?.trim() ?? '';
    return n.isEmpty ? 'there' : n.split(RegExp(r'\s+')).first;
  }

  Account copyWith({String? fullName, Money? walletBalance}) => Account(
    userId: userId,
    phone: phone,
    role: role,
    fullName: fullName ?? this.fullName,
    walletBalance: walletBalance ?? this.walletBalance,
  );

  @override
  String toString() =>
      'Account(userId: $userId, phone: $maskedPhone, role: ${role.name})';
}
