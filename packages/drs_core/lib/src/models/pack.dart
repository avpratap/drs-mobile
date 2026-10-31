import 'package:meta/meta.dart';

import 'money.dart';
import 'product.dart';

/// A purchasable pack size of a product (backend "variant"). Adding one pack
/// to the cart adds `packSize` units of the product (the cart keeps ONE line
/// per product, quantity in the product's uom).
@immutable
class Pack {
  const Pack({
    required this.packSize,
    required this.label,
    this.id,
    this.price,
    this.mrp,
  });

  /// Backend variant id; null for the product's own default pack.
  final int? id;
  final String label;
  final double packSize;

  /// GST-inclusive storefront price (`selling_price`); null = not sold retail.
  final Money? price;
  final Money? mrp;

  bool get available => price != null;

  bool get showMrpStrike =>
      price != null && mrp != null && mrp!.compareTo(price!) > 0;
}

/// Product page data: the product plus its packs.
@immutable
class ProductDetail {
  const ProductDetail({required this.product, required this.packs});

  final Product product;

  /// Active packs in display order; never empty (falls back to the
  /// product's own pack when there are no variants).
  final List<Pack> packs;

  Pack? get defaultPack {
    for (final p in packs) {
      if (p.available) return p;
    }
    return null;
  }
}
