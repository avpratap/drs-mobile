import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'secure_token_store.dart';
import 'session_events.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
DrsEnv env(Ref ref) => DrsEnv.fromEnvironment();

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
