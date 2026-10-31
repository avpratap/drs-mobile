/// Human quantity in a product's unit of measure, e.g. `1.5 L`, `750 ml`,
/// `2 kg`, `3 pcs`.
String formatQty(double qty, String uom) {
  String n(num v) {
    final r = (v * 1000).round() / 1000;
    return r == r.roundToDouble() ? r.toInt().toString() : r.toString();
  }

  final u = uom.toLowerCase();
  if (u.startsWith('l')) return qty < 1 ? '${n(qty * 1000)} ml' : '${n(qty)} L';
  if (u == 'kg') return qty < 1 ? '${n(qty * 1000)} g' : '${n(qty)} kg';
  if (u == 'ml' || u == 'g') return '${n(qty)} $u';
  return qty == 1 ? '1 $uom' : '${n(qty)} × $uom';
}

/// Number of whole packs in [qty] (rounded to the nearest pack).
int packsIn(double qty, double packSize) =>
    packSize <= 0 ? 0 : (qty / packSize).round();

/// Cart quantity for [packs] packs, quantised to 3 dp like the backend.
double qtyFor(int packs, double packSize) =>
    (packs * packSize * 1000).round() / 1000;
