import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:hooks_riverpod/hooks_riverpod.dart' show Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/local/app_database.dart';
import 'secure_token_store.dart';
import 'session_events.dart';

part 'providers.g.dart';

/// Network images on/off (widget tests turn them off: no HTTP, no disk
/// cache plugin).
final networkImagesProvider = Provider<bool>((_) => true);

/// Wall clock (overridden in tests so time-of-day UI is deterministic).
final clockProvider = Provider<DateTime Function()>((_) => DateTime.now);

/// Compile-time config (`--dart-define`). Override in tests.
@Riverpod(keepAlive: true)
DrsEnv env(Ref ref) => DrsEnv.fromEnvironment(
  appFlavor: appFlavor,
  ios: defaultTargetPlatform == TargetPlatform.iOS,
);

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureTokenStore();

@Riverpod(keepAlive: true)
SessionEvents sessionEvents(Ref ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
}

/// The generated, typed DRS client with session handling.
@Riverpod(keepAlive: true)
DrsApi drsApi(Ref ref) {
  final env = ref.watch(envProvider);
  final events = ref.watch(sessionEventsProvider);
  return buildDrsApi(
    baseUrl: env.apiBaseUrl,
    tokenStore: ref.watch(tokenStoreProvider),
    onSessionExpired: events.notifyExpired,
  );
}

/// Local Drift database (catalogue cache — no personal data).
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
