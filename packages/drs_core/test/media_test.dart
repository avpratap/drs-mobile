import 'package:drs_core/drs_core.dart';
import 'package:test/test.dart';

void main() {
  const base = 'https://drs-backend-zvb1.onrender.com';

  group('resolveMediaUrl', () {
    test('server-relative paths from the live backend', () {
      expect(
        resolveMediaUrl('/files/storefront-demo/products/milk-photo.jpg', base),
        '$base/files/storefront-demo/products/milk-photo.jpg',
      );
      expect(resolveMediaUrl('files/a.jpg', base), '$base/files/a.jpg');
    });

    test('an API base with a path does not leak into media URLs', () {
      expect(
        resolveMediaUrl('/files/a.jpg', 'http://10.0.2.2:8000/api/'),
        'http://10.0.2.2:8000/files/a.jpg',
      );
    });

    test('absolute http(s) URLs pass through; other schemes are dropped', () {
      expect(
        resolveMediaUrl('https://cdn.example.in/a.jpg', base),
        'https://cdn.example.in/a.jpg',
      );
      expect(resolveMediaUrl('file:///etc/passwd', base), isNull);
      expect(resolveMediaUrl('data:image/png;base64,AAAA', base), isNull);
    });

    test('blank values', () {
      expect(resolveMediaUrl(null, base), isNull);
      expect(resolveMediaUrl('  ', base), isNull);
    });
  });

  test('categoryLabel turns backend slugs into display names', () {
    expect(categoryLabel('milk'), 'Milk');
    expect(categoryLabel('buttermilk'), 'Buttermilk');
    expect(categoryLabel('dairy-sweets'), 'Dairy sweets');
    expect(categoryLabel('Farm Fresh'), 'Farm Fresh');
  });
}
