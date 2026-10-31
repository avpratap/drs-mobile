import 'dart:convert';

import 'package:drs_api/drs_api_session.dart';

import 'local/app_database.dart';

/// Runs an API call and rethrows any failure as a PII-safe [DrsApiError].
Future<T> guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on Object catch (e) {
    throw DrsApiError.from(e);
  }
}

/// A read that may come from the offline cache.
class Cached<T> {
  const Cached(this.value, {required this.fromCache, this.error});

  final T value;
  final bool fromCache;

  /// Why the network read failed when [fromCache] is a fallback.
  final DrsApiError? error;
}

/// Network-first read with a Drift JSON fallback (offline / server error).
/// [fetch] returns the raw JSON-encodable list of DTOs; [decode] maps it.
Future<Cached<T>> readThrough<T>({
  required AppDatabase db,
  required String key,
  required Future<List<Object?>> Function() fetch,
  required T Function(List<Object?> json) decode,
  DateTime Function() clock = DateTime.now,
}) async {
  try {
    final json = await fetch();
    final encoded = jsonEncode(json);
    await db.writeJson(key, encoded, clock());
    // Decode the round-tripped JSON so online and offline paths are identical.
    return Cached(
      decode(jsonDecode(encoded) as List<Object?>),
      fromCache: false,
    );
  } on Object catch (e) {
    final error = DrsApiError.from(e);
    final cached = await db.readJson(key);
    if (cached == null) throw error;
    return Cached(
      decode(jsonDecode(cached) as List<Object?>),
      fromCache: true,
      error: error,
    );
  }
}
