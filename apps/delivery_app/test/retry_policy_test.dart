import 'dart:math';

import 'package:delivery_app/src/features/sync/retry_policy.dart';
import 'package:flutter_test/flutter_test.dart';

class _Fixed implements Random {
  _Fixed(this.v);
  final double v;
  @override
  double nextDouble() => v;
  @override
  bool nextBool() => false;
  @override
  int nextInt(int max) => 0;
}

void main() {
  test('exponential from 30s, jittered 50–100%, capped at 15 min', () {
    Duration d(int attempt, double r) => retryDelay(attempt, random: _Fixed(r));
    expect(d(0, 1), const Duration(seconds: 30));
    expect(d(0, 0), const Duration(seconds: 15));
    expect(d(1, 1), const Duration(minutes: 1));
    expect(d(3, 1), const Duration(minutes: 4));
    expect(d(10, 1), const Duration(minutes: 15));
    expect(d(99, 0), const Duration(minutes: 7, seconds: 30));
  });

  test('a longer Retry-After wins; a shorter one does not', () {
    expect(
      retryDelay(0, random: _Fixed(1), retryAfter: const Duration(minutes: 2)),
      const Duration(minutes: 2),
    );
    expect(
      retryDelay(3, random: _Fixed(1), retryAfter: const Duration(seconds: 5)),
      const Duration(minutes: 4),
    );
  });

  test('Retry-After: seconds and HTTP-date', () {
    expect(parseRetryAfter('120'), const Duration(minutes: 2));
    expect(
      parseRetryAfter(
        'Sun, 01 Nov 2026 08:05:00 GMT',
        now: DateTime.utc(2026, 11, 1, 8),
      ),
      const Duration(minutes: 5),
    );
    expect(parseRetryAfter(null), isNull);
    expect(parseRetryAfter('soon'), isNull);
  });

  test('route staleness', () {
    final now = DateTime(2026, 11, 1, 8);
    expect(isStale(now.subtract(const Duration(minutes: 10)), now), isFalse);
    expect(isStale(now.subtract(const Duration(minutes: 16)), now), isTrue);
    expect(isStale(null, now), isTrue);
  });
}
