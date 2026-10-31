import 'package:meta/meta.dart';

import 'money.dart';

/// One cart line. The backend keeps one line per product; [qty] is in the
/// product's uom (e.g. 1.5 = three 500 ml packs).
@immutable
class CartLine {
  const CartLine({
    required this.itemId,
    required this.productId,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int itemId;
  final int productId;
  final double qty;
  final Money unitPrice;

  /// GST-inclusive, computed by the server (round(unit × qty, 2)).
  final Money lineTotal;
}

@immutable
class Cart {
  const Cart({required this.id, required this.lines, required this.subtotal});

  static const empty = Cart(id: 0, lines: [], subtotal: Money.zero);

  final int id;
  final List<CartLine> lines;

  /// Server-computed, GST-inclusive.
  final Money subtotal;

  bool get isEmpty => lines.isEmpty;
  int get lineCount => lines.length;

  CartLine? lineFor(int productId) {
    for (final l in lines) {
      if (l.productId == productId) return l;
    }
    return null;
  }
}

/// Pre-pay quote from `cart_quote`: the authoritative totals to show before
/// paying. Prices are GST-inclusive; [taxTotal] is the GST *inside* [total].
@immutable
class CartQuote {
  const CartQuote({
    required this.subtotal,
    required this.discount,
    required this.taxTotal,
    required this.total,
    this.serviceable,
    this.etaDays,
    this.shipping,
  });

  final Money subtotal;
  final Money discount;
  final Money taxTotal;
  final Money total;

  /// Null when no pincode was supplied.
  final bool? serviceable;
  final int? etaDays;
  final Money? shipping;
}
