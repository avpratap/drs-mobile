import 'package:customer_app/src/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Crash-durable checkout idempotency keys: a retry after a process kill must REPLAY on the
/// server (same key) instead of creating a duplicate order/payment, while a deliberate
/// re-order of the same cart after the TTL gets a fresh key.
void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('replays the stored key within the TTL, then rotates after it', () async {
    var now = DateTime(2026, 11, 1, 8, 0);
    DateTime clock() => now;
    var created = 0;
    String make() => 'key-${created++}';
    const ttl = Duration(minutes: 30);

    final first = await db.idempotencyKey('order', 'fp1', ttl, make, clock: clock);
    expect(first, 'key-0');

    // A crash-retry minutes later reuses the SAME key (no second order on the server).
    now = now.add(const Duration(minutes: 5));
    final retry = await db.idempotencyKey('order', 'fp1', ttl, make, clock: clock);
    expect(retry, 'key-0');
    expect(created, 1); // nothing new was generated

    // A different cart fingerprint gets its own key.
    expect(await db.idempotencyKey('order', 'fp2', ttl, make, clock: clock), 'key-1');

    // After the TTL a deliberate re-order of the same cart gets a FRESH key.
    now = now.add(const Duration(minutes: 31));
    expect(await db.idempotencyKey('order', 'fp1', ttl, make, clock: clock), 'key-2');
  });

  test('keys are wiped on sign-out (clearUserData)', () async {
    DateTime clock() => DateTime(2026, 11, 1, 8, 0);
    final k1 = await db.idempotencyKey('order', 'fp1', const Duration(minutes: 30),
        () => 'k1', clock: clock);
    await db.clearUserData();
    // After a sign-out the fingerprint has no stored key -> a new one is minted.
    final k2 = await db.idempotencyKey('order', 'fp1', const Duration(minutes: 30),
        () => 'k2', clock: clock);
    expect(k1, 'k1');
    expect(k2, 'k2');
  });
}
