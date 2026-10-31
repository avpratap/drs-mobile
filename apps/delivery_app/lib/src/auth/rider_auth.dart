import 'dart:async';

import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/providers.dart';

part 'rider_auth.g.dart';

/// Signed-in rider, or null when signed out.
@Riverpod(keepAlive: true)
class RiderAuth extends _$RiderAuth {
  static const _riderRoles = {AccountRole.delivery, AccountRole.admin};

  AuthApi get _api => ref.read(drsApiProvider).getAuthApi();
  TokenStore get _tokens => ref.read(tokenStoreProvider);

  @override
  Future<Account?> build() async {
    final sub = ref
        .watch(sessionEventsProvider)
        .expired
        .listen((_) => state = const AsyncData(null));
    ref.onDispose(sub.cancel);

    if (await _tokens.read() == null) return null;
    try {
      return await _loadRider();
    } on DrsApiError catch (e) {
      if (e.kind == DrsApiErrorKind.unauthorized ||
          e.kind == DrsApiErrorKind.forbidden) {
        await _tokens.clear();
        return null;
      }
      rethrow;
    }
  }

  Future<String?> requestOtp(String e164Phone) async {
    try {
      final res = await _api.requestOtp(
        oTPRequest: OTPRequest(phone: e164Phone),
      );
      return res.data?.devOtp;
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
  }

  /// Verifies the OTP and admits only delivery staff.
  Future<void> verifyOtp(String e164Phone, String otp) async {
    try {
      final pair = (await _api.verifyOtp(
        oTPVerify: OTPVerify(phone: e164Phone, otp: otp),
      )).data!;
      await _tokens.write(
        SessionTokens(
          accessToken: pair.accessToken,
          refreshToken: pair.refreshToken,
        ),
      );
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
    final rider = await _loadRider();
    if (ref.mounted) state = AsyncData(rider);
  }

  Future<Account> _loadRider() async {
    final UserOut me;
    try {
      me = (await _api.getMe()).data!;
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
    final role = AccountRole.parse(me.role);
    if (!_riderRoles.contains(role)) {
      await signOut();
      throw const DrsApiError(
        DrsApiErrorKind.forbidden,
        'This app is for DRS delivery partners. Please use the DRS app instead.',
      );
    }
    return Account(
      userId: me.id,
      phone: me.phone,
      role: role,
      fullName: me.fullName,
    );
  }

  Future<void> signOut() async {
    final tokens = await _tokens.read();
    if (tokens != null) {
      try {
        await _api.logout(
          refreshRequest: RefreshRequest(refreshToken: tokens.refreshToken),
        );
      } on Object {
        // Best effort.
      }
    }
    await _tokens.clear();
    // DPDP: route/contact cache, unsynced actions and POD photos go with
    // the session.
    await ref.read(deliveryDatabaseProvider).clearAll();
    await ref.read(podFilesProvider).discardAll();
    if (ref.mounted) state = const AsyncData(null);
  }
}
