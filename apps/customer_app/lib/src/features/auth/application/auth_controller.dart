import 'dart:async';

import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart' show notificationsControllerProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/auth_repository.dart';

part 'auth_controller.g.dart';

sealed class AuthState {
  const AuthState();
}

final class SignedOut extends AuthState {
  const SignedOut();
}

final class SignedIn extends AuthState {
  const SignedIn(this.account);

  /// Null when a session exists but the profile couldn't be loaded yet
  /// (e.g. app started offline) — the user stays signed in.
  final Account? account;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository(
  api: ref.watch(drsApiProvider).getAuthApi(),
  tokens: ref.watch(tokenStoreProvider),
);

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    final sub = ref
        .watch(sessionEventsProvider)
        .expired
        .listen((_) => state = const AsyncData(SignedOut()));
    ref.onDispose(sub.cancel);

    final repo = ref.watch(authRepositoryProvider);
    if (!await repo.hasSession()) return const SignedOut();
    // Fast, offline-first cold start: a stored session opens the app at
    // once; the profile loads in the background. A revoked session is
    // caught by the refresh interceptor (-> session expired -> SignedOut).
    unawaited(Future<void>(_loadProfileAfterStart));
    return const SignedIn(null);
  }

  Future<void> _loadProfileAfterStart() async {
    try {
      final account = await ref.read(authRepositoryProvider).currentAccount();
      if (ref.mounted && state.value is SignedIn) {
        state = AsyncData(SignedIn(account));
      }
    } on DrsApiError catch (e) {
      if (e.kind == DrsApiErrorKind.unauthorized && ref.mounted) {
        state = const AsyncData(SignedOut());
      }
      // Offline / server trouble: stay signed in with what we have.
    }
  }

  /// Returns the dev OTP (non-prod only) so the UI can offer to fill it.
  Future<String?> requestOtp(String e164Phone) =>
      ref.read(authRepositoryProvider).requestOtp(e164Phone);

  /// Throws [DrsApiError] on failure; on success the router redirects.
  Future<void> verifyOtp(String e164Phone, String otp) async {
    final account = await ref
        .read(authRepositoryProvider)
        .verifyOtp(e164Phone, otp);
    if (ref.mounted) state = AsyncData(SignedIn(account));
  }

  Future<void> reloadAccount() async {
    try {
      final account = await ref.read(authRepositoryProvider).currentAccount();
      if (ref.mounted) state = AsyncData(SignedIn(account));
    } on DrsApiError {
      // Keep the current state; screens show what they have.
    }
  }

  Future<void> signOut() async {
    // Deactivate this device's push token while the session is still valid.
    await ref.read(notificationsControllerProvider.notifier).signOut();
    await ref.read(authRepositoryProvider).signOut();
    // DPDP: drop cached order history / standing orders with the session.
    await ref.read(appDatabaseProvider).clearUserData();
    if (ref.mounted) state = const AsyncData(SignedOut());
  }
}
