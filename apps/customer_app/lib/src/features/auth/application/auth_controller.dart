import 'dart:async';

import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
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
    try {
      return SignedIn(await repo.currentAccount());
    } on DrsApiError catch (e) {
      if (e.kind == DrsApiErrorKind.unauthorized) return const SignedOut();
      // Offline-first: keep the session, load the profile later.
      return const SignedIn(null);
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
    await ref.read(authRepositoryProvider).signOut();
    // DPDP: drop cached order history / standing orders with the session.
    await ref.read(appDatabaseProvider).clearUserData();
    if (ref.mounted) state = const AsyncData(SignedOut());
  }
}
