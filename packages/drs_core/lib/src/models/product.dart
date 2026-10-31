import 'package:meta/meta.dart';

import 'money.dart';

/// DRS product lines. Drives merchandising and the brand accent: the `sky`
/// colour is reserved for the milk / buttermilk line only.
enum ProductLine {
  milk,
  buttermilk,
  ghee,
  curd,
  paneer,
  other;

  /// Maps the backend's free-text `category` (e.g. "Milk", "Chaas") to a line.
  static ProductLine fromCategory(String? category) {
    final c = (category ?? '').trim().toLowerCase();
    if (c.contains('buttermilk') ||
        c.contains('chaas') ||
        c.contains('chhach')) {
      return ProductLine.buttermilk;
    }
    if (c.contains('milk') || c.contains('doodh')) return ProductLine.milk;
    if (c.contains('ghee')) return ProductLine.ghee;
    if (c.contains('curd') || c.contains('dahi') || c.contains('yogurt')) {
      return ProductLine.curd;
    }
    if (c.contains('paneer')) return ProductLine.paneer;
    return ProductLine.other;
  }

  /// True for the lines that use the `sky` accent.
  bool get usesSkyAccent =>
      this == ProductLine.milk || this == ProductLine.buttermilk;
}

/// A catalogue product (domain model — independent of the wire DTO).
@immutable
class Product {
  const Product({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    this.category,
    this.uom = 'piece',
    this.packSize = 1,
    this.fromPrice,
    this.imageUrl,
    this.isSubscribable = true,
    this.perishable = true,
    this.avgRating = 0,
    this.ratingCount = 0,
  });

  final int id;
  final String sku;
  final String name;
  final String? description;
  final String? category;

  /// Unit of measure, e.g. `litre`, `kg`, `piece`.
  final String uom;
  final double packSize;

  /// Lowest GST-inclusive retail price ("from ₹X"); null when not sold retail.
  final Money? fromPrice;
  final String? imageUrl;
  final bool isSubscribable;
  final bool perishable;
  final double avgRating;
  final int ratingCount;

  ProductLine get line => ProductLine.fromCategory(category ?? name);

  /// Human pack label, e.g. `500 ml`, `1 L`, `200 g`.
  String get packLabel {
    final u = uom.toLowerCase();
    String n(num v) =>
        v == v.roundToDouble() ? v.toInt().toString() : v.toString();
    if (u.startsWith('l')) {
      return packSize < 1 ? '${n(packSize * 1000)} ml' : '${n(packSize)} L';
    }
    if (u == 'kg') {
      return packSize < 1 ? '${n(packSize * 1000)} g' : '${n(packSize)} kg';
    }
    if (u == 'ml' || u == 'g') return '${n(packSize)} $u';
    return packSize == 1 ? '1 $uom' : '${n(packSize)} × $uom';
  }

  @override
  bool operator ==(Object other) =>
      other is Product &&
      other.id == id &&
      other.sku == sku &&
      other.name == name &&
      other.fromPrice == fromPrice &&
      other.category == category;

  @override
  int get hashCode => Object.hash(id, sku, name, fromPrice, category);
}
