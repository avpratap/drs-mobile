import 'dart:convert';
import 'dart:io';

import 'package:drs_api/drs_api.dart';
import 'package:test/test.dart';

Object? fixture(String name) =>
    jsonDecode(File('test/fixtures/live/$name.json').readAsStringSync());

void main() {
  group('live backend responses decode with the generated models', () {
    test('product list: relative image paths, lowercase category slugs', () {
      final list = (fixture('products')! as List)
          .map((j) => ProductOut.fromJson(j as Map<String, dynamic>))
          .toList();
      expect(list, hasLength(6));
      expect(list.first.imageUrl, startsWith('/files/'));
      expect(list.map((p) => p.category), everyElement(matches(r'^[a-z]+$')));
    });

    test('categories are plain strings', () {
      expect(fixture('products_categories'), [
        'buttermilk',
        'ghee',
        'milk',
        'paneer',
        'sweets',
      ]);
    });

    test('product detail with and without pack-size variants', () {
      final withPacks = ProductFullOut.fromJson(
        fixture('products_1_full')! as Map<String, dynamic>,
      );
      expect(withPacks.variants, hasLength(2));
      final bare = ProductFullOut.fromJson(
        fixture('products_3_full')! as Map<String, dynamic>,
      );
      expect(bare.variants, isEmpty);
    });

    test('ratings: anonymous reviews, string-keyed distribution', () {
      final r = ProductRatingsOut.fromJson(
        fixture('products_1_ratings')! as Map<String, dynamic>,
      );
      expect(r.count, r.distribution.values.fold<int>(0, (a, b) => a + b));
      expect(r.ratings.map((x) => x.userId), everyElement(isNull));
    });
  });
}
