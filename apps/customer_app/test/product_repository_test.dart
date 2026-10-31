import 'package:customer_app/src/data/local/app_database.dart';
import 'package:customer_app/src/features/catalogue/data/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_backend.dart';

void main() {
  late AppDatabase db;
  late FakeBackend backend;
  late ProductRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    backend = FakeBackend({
      'GET /api/v1/products': (_) => FakeBackend.json(200, sampleProducts),
    });
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = backend;
    repo = ProductRepository(
      api: ProductsApi(dio),
      db: db,
      clock: () => DateTime.utc(2026, 10, 31, 6),
    );
  });

  tearDown(() => db.close());

  test('online refresh maps DTOs and writes the Drift cache', () async {
    final snap = await repo.refresh();

    expect(snap.fromCache, isFalse);
    expect(snap.products.map((p) => p.sku), [
      'GHEE-500',
      'MILK-500',
      'CHAAS-200',
    ]);
    expect(snap.products[1].fromPrice, Money.fromRupees(32));
    expect(snap.products[1].line, ProductLine.milk);
    expect(snap.categories, ['Ghee', 'Milk', 'Buttermilk']);
    expect(await db.cachedCatalogue(), hasLength(3));
  });

  test('offline falls back to the cached catalogue in server order', () async {
    await repo.refresh();
    backend.offline = true;

    final snap = await repo.refresh();

    expect(snap.fromCache, isTrue);
    expect(snap.error?.kind, DrsApiErrorKind.offline);
    expect(snap.products.map((p) => p.id), [1, 2, 3]);
    expect(snap.products.first.fromPrice, Money.fromRupees(749));
    expect(
      snap.fetchedAt!.isAtSameMomentAs(DateTime.utc(2026, 10, 31, 6)),
      isTrue,
    );
  });

  test('offline with an empty cache throws a typed error', () async {
    backend.offline = true;
    await expectLater(
      repo.refresh(),
      throwsA(
        isA<DrsApiError>().having(
          (e) => e.kind,
          'kind',
          DrsApiErrorKind.offline,
        ),
      ),
    );
  });

  test('a fresh snapshot replaces stale rows', () async {
    await repo.refresh();
    backend.routes['GET /api/v1/products'] = (_) =>
        FakeBackend.json(200, [sampleProducts.first]);
    await repo.refresh();
    expect(await db.cachedCatalogue(), hasLength(1));
  });
}
