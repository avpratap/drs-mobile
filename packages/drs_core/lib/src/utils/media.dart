/// Resolves a media path from the API against the backend origin.
///
/// The backend returns catalogue images as server-relative paths
/// (`/files/storefront-demo/products/milk-photo.jpg`); absolute URLs (a CDN)
/// pass through unchanged. Returns null for missing/blank values or anything
/// that isn't http(s) (no `file:`/`data:` from the network).
String? resolveMediaUrl(String? raw, String apiBaseUrl) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  final parsed = Uri.tryParse(value);
  if (parsed == null) return null;
  if (parsed.hasScheme) {
    return (parsed.isScheme('https') || parsed.isScheme('http')) ? value : null;
  }
  final base = Uri.tryParse(apiBaseUrl);
  if (base == null || !base.hasScheme || base.host.isEmpty) return null;
  // Resolve against the origin's root so `/files/x` and `files/x` both work
  // and an API base with a path doesn't leak into media URLs.
  final origin = base.replace(path: '/', query: null, fragment: null);
  return origin.resolve(value.startsWith('/') ? value : '/$value').toString();
}

/// Display name for a backend category slug (`buttermilk` → "Buttermilk",
/// `dairy-sweets` → "Dairy sweets"). Free-text categories keep their case.
String categoryLabel(String category) {
  final c = category.trim();
  if (c.isEmpty) return c;
  const known = {
    'milk': 'Milk',
    'buttermilk': 'Buttermilk',
    'chaas': 'Chaas',
    'ghee': 'Ghee',
    'curd': 'Curd',
    'dahi': 'Dahi',
    'paneer': 'Paneer',
    'sweets': 'Sweets',
    'butter': 'Butter',
  };
  final hit = known[c.toLowerCase()];
  if (hit != null) return hit;
  if (c != c.toLowerCase()) return c; // already a display name
  final words = c.replaceAll(RegExp('[-_]+'), ' ');
  return words[0].toUpperCase() + words.substring(1);
}
