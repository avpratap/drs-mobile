import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// An INR amount stored as integer **paise** to avoid floating-point drift.
///
/// The backend speaks rupees as JSON numbers (e.g. `42.5`); convert at the
/// edge with [Money.fromRupees] and keep arithmetic in paise.
@immutable
class Money implements Comparable<Money> {
  const Money.paise(this.paise);

  factory Money.fromRupees(num rupees) => Money.paise((rupees * 100).round());

  static const zero = Money.paise(0);

  final int paise;

  double get rupees => paise / 100;
  bool get isZero => paise == 0;
  bool get isNegative => paise < 0;

  Money operator +(Money other) => Money.paise(paise + other.paise);
  Money operator -(Money other) => Money.paise(paise - other.paise);
  Money operator -() => Money.paise(-paise);

  /// Multiplies by a (possibly fractional) quantity, e.g. 1.5 litres.
  Money times(num qty) => Money.paise((paise * qty).round());

  static final _withPaise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  static final _wholeRupees = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Indian-grouped currency string: `₹1,23,456.50`, or `₹45` when the
  /// amount is whole rupees and [compact] is true.
  String format({bool compact = true}) {
    if (compact && paise % 100 == 0) return _wholeRupees.format(rupees);
    return _withPaise.format(rupees);
  }

  @override
  int compareTo(Money other) => paise.compareTo(other.paise);

  @override
  bool operator ==(Object other) => other is Money && other.paise == paise;

  @override
  int get hashCode => paise.hashCode;

  @override
  String toString() => format(compact: false);
}
