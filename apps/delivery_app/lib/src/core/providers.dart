import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/delivery_database.dart';
import '../data/pod_files.dart';
import 'secure_token_store.dart';
import 'session_events.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
DrsEnv env(Ref ref) => DrsEnv.fromEnvironment(
  appFlavor: appFlavor,
  ios: defaultTargetPlatform == TargetPlatform.iOS,
);

/// Wall clock (pinned in tests: "updated at" / staleness / retry backoff).
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureTokenStore();

@Riverpod(keepAlive: true)
SessionEvents sessionEvents(Ref ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
}

@Riverpod(keepAlive: true)
DrsApi drsApi(Ref ref) => buildDrsApi(
  baseUrl: ref.watch(envProvider).apiBaseUrl,
  tokenStore: ref.watch(tokenStoreProvider),
  onSessionExpired: ref.watch(sessionEventsProvider).notifyExpired,
);

@Riverpod(keepAlive: true)
DeliveryDatabase deliveryDatabase(Ref ref) {
  final db = DeliveryDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
PodFiles podFiles(Ref ref) => PodFiles();

/// Background sync triggers (connectivity, resume, timer). Off in tests.
@Riverpod(keepAlive: true)
bool autoSync(Ref ref) => true;
